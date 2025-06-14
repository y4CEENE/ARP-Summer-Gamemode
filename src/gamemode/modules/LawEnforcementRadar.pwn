#include <YSI\y_hooks>

static CarRadars[MAX_PLAYERS];

static PlayerText:_crTextTarget[MAX_PLAYERS];
static PlayerText:_crTextSpeed[MAX_PLAYERS];
static PlayerText:_crTickets[MAX_PLAYERS];

hook OnPlayerExitVehicle(playerid, vehicleid)
{

	if (CarRadars[playerid] == 1)
	{
		CarRadars[playerid] = 0;
		PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
		PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
		PlayerTextDrawHide(playerid, _crTickets[playerid]);
		DeletePVar(playerid, "_lastTicketWarning");
	}
    return 1;
}


hook OnGameModeInit()
{
	SetTimer("UpdateCarRadars", 300, true);
    return 1;
}


hook OnPlayerInit(playerid)
{
    CarRadars[playerid] = 0;

	_crTextTarget[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 388.000000, "Target Vehicle: ~r~N/A");
	PlayerTextDrawAlignment(playerid, _crTextTarget[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, _crTextTarget[playerid], 255);
	PlayerTextDrawFont(playerid, _crTextTarget[playerid], 1);
	PlayerTextDrawLetterSize(playerid, _crTextTarget[playerid], 0.500000, 1.600000);
	PlayerTextDrawColor(playerid, _crTextTarget[playerid], -1);
	PlayerTextDrawSetOutline(playerid, _crTextTarget[playerid], 1);
	PlayerTextDrawSetProportional(playerid, _crTextTarget[playerid], 1);

	_crTextSpeed[playerid] = CreatePlayerTextDraw(playerid, 190.000000, 410.000000, "Speed: ~r~N/A");
	PlayerTextDrawAlignment(playerid, _crTextSpeed[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, _crTextSpeed[playerid], 255);
	PlayerTextDrawFont(playerid, _crTextSpeed[playerid], 1);
	PlayerTextDrawLetterSize(playerid, _crTextSpeed[playerid], 0.500000, 1.600000);
	PlayerTextDrawColor(playerid, _crTextSpeed[playerid], -1);
	PlayerTextDrawSetOutline(playerid, _crTextSpeed[playerid], 1);
	PlayerTextDrawSetProportional(playerid, _crTextSpeed[playerid], 1);

	_crTickets[playerid] = CreatePlayerTextDraw(playerid, 340.000000, 410.000000, "Tickets: ~r~N/A");
	PlayerTextDrawAlignment(playerid, _crTickets[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, _crTickets[playerid], 255);
	PlayerTextDrawFont(playerid, _crTickets[playerid], 1);
	PlayerTextDrawLetterSize(playerid, _crTickets[playerid], 0.500000, 1.600000);
	PlayerTextDrawColor(playerid, _crTickets[playerid], -1);
	PlayerTextDrawSetOutline(playerid, _crTickets[playerid], 1);
	PlayerTextDrawSetProportional(playerid, _crTickets[playerid], 1);
	    
    return 1;
}
    

hook OnPlayerDeath(playerid, killerid, reason)
{
	if (CarRadars[playerid] == 1)
	{
		CarRadars[playerid] = 0;
		PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
		PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
		PlayerTextDrawHide(playerid, _crTickets[playerid]);
		DeletePVar(playerid, "_lastTicketWarning");
	}
    return 1;
}


hook OnPlayerHeartBeat(playerid)
{	
	if (!IsPlayerConnected(playerid) || !IsPlayerInAnyVehicle(playerid) || CarRadars[playerid] == 0)
    {
        return playerid;
    }

    new targetid = -1;
    new Float:tempDist = 50.0;

    if(CarRadars[playerid] == 1)
    {
        foreach(new t : Player)
        {
            if (!IsPlayerInAnyVehicle(t) || t == playerid || IsPlayerInVehicle(t, GetPlayerVehicleID(playerid))) continue;

            new Float:distance = GetDistanceBetweenPlayers(playerid, t);

            if (distance < tempDist)
            {
                targetid = t;
                tempDist = distance;
            }
        }

        if (targetid == -1)
        {
            // no target was found
            PlayerTextDrawSetString(playerid, _crTextTarget [playerid], "Target Vehicle: ~r~N/A");
            PlayerTextDrawSetString(playerid, _crTextSpeed  [playerid], "Speed: ~r~N/A");
            PlayerTextDrawSetString(playerid, _crTickets    [playerid], "Tickets: ~r~N/A");
        }
        else
        {
            new targetVehicle = GetPlayerVehicleID(targetid);
            new Float: speed = player_get_speed(targetid);

            new str[60];

            format(str, sizeof(str), "Target Vehicle: ~r~%s (%i)", GetVehicleName(targetVehicle), targetVehicle);
            PlayerTextDrawSetString(playerid, _crTextTarget[playerid], str);
            format(str, sizeof(str), "Speed: ~r~%d MPH", floatround(speed, floatround_round));
            PlayerTextDrawSetString(playerid, _crTextSpeed[playerid], str);
            foreach(new i : Player)
            {
                new veh = GetPlayerVehicle(i, targetVehicle);
                if (veh != -1 && VehicleInfo[veh][vTickets] > 0)
                {
                    format(str, sizeof(str), "Tickets: ~r~$%s", FormatCash(VehicleInfo[veh][vTickets]));
                    PlayerTextDrawSetString(playerid, _crTickets[playerid], str);
                    
                    if (gettime() >= (GetPVarInt(playerid, "_lastTicketWarning") + 10))
                    {
                        SetPVarInt(playerid, "_lastTicketWarning", gettime());
                        PlayerPlaySound(playerid, 4202, 0.0, 0.0, 0.0);
                    }
                }
            }
        }
    }

    return 1;
	
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		if (CarRadars[playerid] == 1)
		{
            CarRadars[playerid] = 0;
			PlayerTextDrawShow(playerid, _crTextTarget[playerid]);
			PlayerTextDrawShow(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawShow(playerid, _crTickets[playerid]);
			DeletePVar(playerid, "_lastTicketWarning");
		}
    }
    return 1;
}


CMD:vradar(playerid, params[])
{

	if(!IsLawEnforcement(playerid))
    {
	    return SendClientMessageEx(playerid, COLOR_GREY, "You are not a law enforcement officer!");
    }

	if (!IsPlayerInAnyVehicle(playerid))
    {
		return SendClientMessageEx(playerid, 0xFF0000FF, "You cannot use a dashboard radar outside of a vehicle.");
    }

    if (CarRadars[playerid] == 0) // player has not deployed dashboard radar
    {
        CarRadars[playerid] = 1;
        PlayerTextDrawShow(playerid, _crTextTarget[playerid]);
        PlayerTextDrawShow(playerid, _crTextSpeed[playerid]);
        PlayerTextDrawShow(playerid, _crTickets[playerid]);

        SendClientMessageEx(playerid, COLOR_WHITE, "You are now using your dashboard radar.");
        SetPVarInt(playerid, "_lastTicketWarning", 0);
    }
    else // dashboard radar has been deployed
    {
        CarRadars[playerid] = 0;
        PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
        PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
        PlayerTextDrawHide(playerid, _crTickets[playerid]);

        SendClientMessageEx(playerid, COLOR_WHITE, "You are no longer using your dashboard radar.");
        DeletePVar(playerid, "_lastTicketWarning");
    }

	return 1;
}
