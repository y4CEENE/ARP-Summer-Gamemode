/*
	SACNR Monitor Announce Filterscript

	Use this filterscript if your server is not on the internet list, but you
	want it to show up on SACNR Monitor.

	Contributors:
		Blacklite
		King_Hual
		Jamie
		Blake
*/

#include <YSI\y_hooks>

#define SACNR_ANNOUNCE_URL        "monitor.sacnr.com/api/?Action=announce"

#define HTTP_SACNR_CREATED                201
#define HTTP_SACNR_FORBIDDEN			  403
#define HTTP_SACNR_UNPROCESSABLE_ENTITY   422
#define HTTP_SACNR_TOO_MANY_REQUESTS      429

hook OnGameModeInit()
{
    if(IsProductionServer())
    {
        return 1;
    }
    new postData[32],
        ip[16],
        port;

    port = GetServerVarAsInt("port");
    
    if(!IsProductionServer())
    {
        printf("[SACNR MONITOR] Skiping server announcement.");    
        return 1;
    }
    printf("[SACNR MONITOR] Announcing server...");

    GetServerVarAsString("bind", ip, sizeof(ip));

    if (!strlen(ip)) 
    {
        printf("[SACNR MONITOR] Bind address empty, can't announce server");
        return 1;
    }
    format(postData, sizeof(postData), "ipp=%s:%d", ip, port);
    HTTP(0, HTTP_POST, SACNR_ANNOUNCE_URL, postData, "OnAnnounced"); // no need for different announce indices
    return 1;
}


forward OnAnnounced(index, response_code, data[]);
public OnAnnounced(index, response_code, data[])
{
    #pragma unused data
    switch (response_code) 
    {
        case HTTP_ERROR_BAD_HOST: {
            printf("[SACNR MONITOR] Server failed to announce: HTTP_ERROR_BAD_HOST");
        }
        case HTTP_ERROR_NO_SOCKET: {
            printf("[SACNR MONITOR] Server failed to announce: HTTP_ERROR_NO_SOCKET");
        }
        case HTTP_ERROR_CANT_CONNECT: {
            printf("[SACNR MONITOR] Server failed to announce: HTTP_ERROR_CANT_CONNECT");
        }
        case HTTP_ERROR_CANT_WRITE: {
            printf("[SACNR MONITOR] Server failed to announce: HTTP_ERROR_CANT_WRITE");
        }
        case HTTP_ERROR_CONTENT_TOO_BIG: {
            printf("[SACNR MONITOR] Server failed to announce: HTTP_ERROR_CONTENT_TOO_BIG");
        }
        case HTTP_ERROR_MALFORMED_RESPONSE: {
            printf("[SACNR MONITOR] Server failed to announce: HTTP_ERROR_MALFORMED_RESPONSE");
        }
        case HTTP_SACNR_CREATED: {
            printf("[SACNR MONITOR] Server announced successfully.");
        }
        case HTTP_SACNR_FORBIDDEN: {
        	printf("[SACNR MONITOR] Server failed to announce: 403 Forbidden. This can happen if your server has multiple IP addresses or lots of public SA-MP servers on your subnet.");
        }
        case HTTP_SACNR_UNPROCESSABLE_ENTITY: {
            printf("[SACNR MONITOR] Server failed to announce: 422 Unprocessable Entity. You might get this error if you are running a local/LAN server.");
        }
        case HTTP_SACNR_TOO_MANY_REQUESTS: {
            printf("[SACNR MONITOR] Server already announced (interval too small?).");
        }
        default: {
            printf("[SACNR MONITOR] Server failed to announce (error %d).", response_code);
        }
    }
}