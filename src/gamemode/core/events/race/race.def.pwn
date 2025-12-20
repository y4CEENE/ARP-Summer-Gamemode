


//============================= Race Varaibles ======================================//
new Float:CP_SIZE = 10.0;
new RACE_STARTED;
new RACE_ADMIN_ID;
new RACE_CP[MAX_PLAYERS];
new PLAYER_IN_RACE[MAX_PLAYERS];
new CREATING_RACE_CHECKPOINTS;
new CP_COUNTER;
new Float:Rx[100] , Float:Ry[100] , Float:Rz[100];
new RACE_COUNT_DOWN , RACE_TIMER;
new RACE_EVENT_ACTIVE;
new FREEZE_PLAYER[MAX_PLAYERS];
new RaceVehicles[MAX_PLAYERS];
new RACE_CREATED;
new TOTAL_RACE_CP;
new Cash[] = {50000,100000,80000,90000,70000};