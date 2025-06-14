#include <YSI\y_hooks>
// Anti Dialog ID spoofing

#define DIALOG_ID 32700
#define Dialog:%0(%1) \
	forward dlg_%0(%1); public dlg_%0(%1)

#define Dialog_Show(%0,%1, \
	Dialog_Open(%0, #%1,

static s_DialogName[MAX_PLAYERS][32];
static bool: s_DialogOpened[MAX_PLAYERS];


forward IsDialogOpened(playerid);
public IsDialogOpened(playerid)
{
	return (s_DialogOpened[playerid]);
}

Dialog_Open(playerid, function[], style, caption[], info[], button1[], button2[], {Float,_}:...)
{
	static
		string[4096],
		args;

	if (!strlen(info))
	{
		return 0;
	}
    
    SetPVarInt(playerid, "DialogID", DIALOG_ID);

	if ((args = numargs()) > 7)
	{
		while (--args >= 7)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S info
		#emit PUSH.C 4096
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 16
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		ShowPlayerDialog(playerid, DIALOG_ID, style, caption, string, button1, button2);
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_ID, style, caption, info, button1, button2);
	}
	s_DialogOpened[playerid] = true;

	format(s_DialogName[playerid], 32, function);

	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string[128];

    if(!isnull(inputtext))
    {
        if(strfind(inputtext, "%s", true) != -1)
        {
            KickPlayer(playerid, "Dialog-exploiting by attempting to send a null string");
			return 1;
        }
    }
	
	// Currently we don't support anti-spoffing for DIALOG_MSTORE

    if(GetPVarInt(playerid, "DialogID") != dialogid && dialogid != DIALOG_MSTORE) // Confirm the dialogid matches what we have in the PVar
    { 
        
        format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) is possibly trying to spoof a dialog ID (%d).", GetPlayerNameEx(playerid), playerid, dialogid);
        ABroadCast(COLOR_YELLOW, string, 2);

        //format(string, sizeof(string), "%s has possibly tried to spoof a dialog ID.", GetPlayerNameEx(playerid));
        //AddAutomatedFlag(playerid, string);

        Log("Rex/Anti-DialogSpoffing.log", "%s has possibly tried to spoof a dialog ID (%d, %d).", GetPlayerNameEx(playerid), dialogid, response);
        return 1;
    }
    
    DeletePVar(playerid, "DialogID"); // Delete the PVar now we're done with it

	// Sanitize inputs.
	for (new i = 0, l = strlen(inputtext); i < l; i ++)
	{
		if (inputtext[i] == '%')
		{
			inputtext[i] = '#';
		}
	}
	
	if (dialogid == DIALOG_ID && strlen(s_DialogName[playerid]) > 0)
	{
        s_DialogName[playerid]{0} = 0;
        s_DialogOpened[playerid] = false;

		strcat(string, "dlg_");
		strcat(string, s_DialogName[playerid]);
		CallLocalFunction(string, "ddds", playerid, response, listitem, (!inputtext[0]) ? ("\1") : (inputtext));
	}

    return 1;
}

