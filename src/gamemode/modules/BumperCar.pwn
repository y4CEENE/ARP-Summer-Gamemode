#include <stdlib.h>  // For rand() and srand()
#include <time.h>    // For time()

void UpdateServerName()
{
    // List of possible names
    const char* names[] = {
        "ArabicaRolePlay",
        "ArabicaRP",
        "Arabica Beta"
    };
    
    // Get the number of names
    int nameCount = sizeof(names) / sizeof(names[0]);
    
    // Seed random number generator (do this once at server start ideally)
    srand((unsigned int)time(NULL));
    
    // Pick a random index
    int index = rand() % nameCount;
    
    // Set the server hostname
    char hostname[256];
    snprintf(hostname, sizeof(hostname), "%s", names[index]);
    SetServerHostName(hostname);
}
