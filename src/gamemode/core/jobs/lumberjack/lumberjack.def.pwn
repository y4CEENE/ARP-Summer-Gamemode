#define MAX_LUMBERJACK_TREES (35)   // tree limit
#define     MAX_LOGS         (300)   // dropped log limit
#define     MAX_BUYERS       (20)    // log buyer limit
#define		LJ_RESPAWN_CAR	 (1800)  // respawn car timer
#define     CUTTING_TIME     (8)		// required seconds to cut a tree down (Default: 8)
#define     LOG_LIMIT     	 (10)    // how many logs a player can load to a bobcat (if you change this, don't forget to modify LogAttachOffsets array) (Default: 10)
#define     ATTACH_INDEX     (7)     // for setplayerattachedobject (Default: 7)
#define     TREE_RESPAWN     (300)   // required seconds to respawn a tree (Default: 300)
#define     LOG_LIFETIME	 (120)   // life time of a dropped log, in seconds (Default: 120)
#define     LOG_PRICE        (800)   // price of a log (Default: 800)
#define     CSAW_PRICE       (500)  	// price of a chainsaw (Default: 500)

enum    E_TREE
{
	// loaded from db
	Float: treeX,
	Float: treeY,
	Float: treeZ,
	Float: treeRX,
	Float: treeRY,
	Float: treeRZ,
	// temp
	treeLogs,
	treeSeconds,
	bool: treeGettingCut,
	treeObjID,
	Text3D: treeLabel,
	treeTimer
};

enum    E_LOG
{
	// temp
	logDroppedBy[MAX_PLAYER_NAME],
	logSeconds,
	logObjID,
	logTimer,
	Text3D: logLabel
};

new lumberjackVehicles[6];
new lumberjackTrees[MAX_LUMBERJACK_TREES][E_TREE];

new
	LogData[MAX_LOGS][E_LOG],
	LogObjects[MAX_VEHICLES][LOG_LIMIT];
new
	CuttingTreeID[MAX_PLAYERS] = {-1, ...},
	bool: CarryingLog[MAX_PLAYERS];

new Iterator: Logs<MAX_LOGS>;

new
	Float: LogAttachOffsets[LOG_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};
