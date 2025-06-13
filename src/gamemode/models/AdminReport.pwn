/// @file      AdminReport.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


enum rEnum
{
    rExists,
    rReporter,
    rAccepted,
    rHandledBy,
    rText[128],
    rTime
};

new ReportInfo[MAX_REPORTS][rEnum];
