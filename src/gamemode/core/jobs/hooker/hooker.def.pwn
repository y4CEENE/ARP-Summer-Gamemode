new STDProbability[][] = {
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3},
    {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 3}
};

new STDName[][14]={
    "no STI",
    "a Chlamydia",
    "a Gonorrhea",
    "a Syphilis"
};

new SexOffer[MAX_PLAYERS];
new SexPrice[MAX_PLAYERS];
new SexLastTime[MAX_PLAYERS];
new STD[MAX_PLAYERS];
new STDTimerId[MAX_PLAYERS];