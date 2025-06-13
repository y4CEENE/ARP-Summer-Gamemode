#include <YSI\y_hooks>

static bool:FPSPlayerState[MAX_PLAYERS];
static FPSCameraObject[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    FPSPlayerState[playerid] = false;
    return 1;
}

public SetThirdPersonView(playerid, bool:status)
{
	FPSPlayerState[playerid] = status;
	if(status)
	{
		SetCameraBehindPlayer(playerid);
    }
	else
	{
		SyncCamera(playerid);
    }
}

public IsThirdPersonView(playerid)
{
    return FPSPlayerState[playerid];
}

hook OnPlayerUpdate(playerid)
{

    return 1;
}
public SyncCamera(playerid)
{
    if(!IsThirdPersonView(playerid))
    {
        SetCameraBehindPlayer(playerid);
    }
    else
	{
        if(!IsPlayerInAnyVehicle(playerid))
        {
            AttachObjectToPlayer(CameraFirstPerson(playerid), playerid, 0.0, 0.15, 0.65, 0.0, 0.0, 0.0)
            AttachCameraToObject(playerid, CameraFirstPerson(playerid))
        }
		else
        {
            SetCameraBehindPlayer(playerid)
        }
    }
	return 1
}
