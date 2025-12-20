/*
	Mailbox System
	Author: Tr0Y
	Date: 9/4/2025
	
	commands:
	/mailbox create/edit/remove/goto
	/openmailbox 		+R5
	/sendmail 			Mafia +R5
	/clearmails 		GangMod
	/clearmailboxes 	GangMod
*/
#include <YSI\y_hooks>


#define MAILBOX_OBJECT_BOX   1291
#define MAILBOX_RANGE        3.0

enum E_MAILBOX
{
    mGangID,
    Float:mPosX,
    Float:mPosY,
    Float:mPosZ,
    Float:mRotX,
    Float:mRotY,
    Float:mRotZ,
    mObjectID,
    Text3D:mLabelID
};

new MailboxInfo[MAX_GANGS][E_MAILBOX];

new MailListCache[MAX_PLAYERS][1024];
new MailListCount[MAX_PLAYERS];

hook OnGameModeInit()
{
    mysql_tquery(connectionID,
        "CREATE TABLE IF NOT EXISTS mailboxes (\
            id INT AUTO_INCREMENT PRIMARY KEY,\
            gang_id INT NOT NULL,\
            posX FLOAT NOT NULL,\
            posY FLOAT NOT NULL,\
            posZ FLOAT NOT NULL,\
            rotX FLOAT DEFAULT 0.0,\
            rotY FLOAT DEFAULT 0.0,\
            rotZ FLOAT DEFAULT 0.0,\
            modelid INT DEFAULT 1291\
        );"
    );

    mysql_tquery(connectionID,
        "ALTER TABLE mailboxes \
         ADD COLUMN IF NOT EXISTS rotX FLOAT DEFAULT 0.0, \
         ADD COLUMN IF NOT EXISTS rotY FLOAT DEFAULT 0.0, \
         ADD COLUMN IF NOT EXISTS rotZ FLOAT DEFAULT 0.0;"
    );

    mysql_tquery(connectionID,
        "CREATE TABLE IF NOT EXISTS mails (\
            id INT AUTO_INCREMENT PRIMARY KEY,\
            gang_id INT NOT NULL,\
            sender_name VARCHAR(24) NOT NULL,\
            title VARCHAR(64) NOT NULL,\
            body TEXT NOT NULL,\
            send_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP\
        );"
    );

    mysql_tquery(connectionID, "SELECT * FROM mailboxes", "LoadMailboxes");
    return 1;
}


forward LoadMailboxes();
public LoadMailboxes()
{
    new rows, fields;
    cache_get_data(rows, fields);

    for(new g = 0; g < MAX_GANGS; g++)
    {
        if(MailboxInfo[g][mObjectID] != 0)
        {
            DestroyDynamicObject(MailboxInfo[g][mObjectID]);
            MailboxInfo[g][mObjectID] = 0;
        }
        if(MailboxInfo[g][mLabelID] != Text3D:INVALID_3DTEXT_ID)
        {
            DestroyDynamic3DTextLabel(MailboxInfo[g][mLabelID]);
            MailboxInfo[g][mLabelID] = Text3D:INVALID_3DTEXT_ID;
        }

        MailboxInfo[g][mPosX] = 0.0;
        MailboxInfo[g][mPosY] = 0.0;
        MailboxInfo[g][mPosZ] = 0.0;
        MailboxInfo[g][mRotX] = 0.0;
        MailboxInfo[g][mRotY] = 0.0;
        MailboxInfo[g][mRotZ] = 0.0;
        MailboxInfo[g][mGangID] = -1;
    }

    for(new i = 0; i < rows; i++)
    {
        new gangid = cache_get_field_content_int(i, "gang_id");

        MailboxInfo[gangid][mGangID] = gangid;
        MailboxInfo[gangid][mPosX] = cache_get_field_content_float(i, "posX");
        MailboxInfo[gangid][mPosY] = cache_get_field_content_float(i, "posY");
        MailboxInfo[gangid][mPosZ] = cache_get_field_content_float(i, "posZ");
        MailboxInfo[gangid][mRotX] = cache_get_field_content_float(i, "rotX");
        MailboxInfo[gangid][mRotY] = cache_get_field_content_float(i, "rotY");
        MailboxInfo[gangid][mRotZ] = cache_get_field_content_float(i, "rotZ");

        new modelid = cache_get_field_content_int(i, "modelid");
        MailboxInfo[gangid][mObjectID] = CreateDynamicObject(
            modelid,
            MailboxInfo[gangid][mPosX],
            MailboxInfo[gangid][mPosY],
            MailboxInfo[gangid][mPosZ],
            MailboxInfo[gangid][mRotX],
            MailboxInfo[gangid][mRotY],
            MailboxInfo[gangid][mRotZ]
        );
        
        new gangName[64], color;
        color = GangInfo[gangid][gColor];
        format(gangName, sizeof gangName, "{%06x}%s's mailbox\n(( /openmailbox ))",color >>> 8, GangInfo[gangid][gName]);
		
        MailboxInfo[gangid][mLabelID] = CreateDynamic3DTextLabel(gangName, -1, MailboxInfo[gangid][mPosX], MailboxInfo[gangid][mPosY], MailboxInfo[gangid][mPosZ] + 1.0, 15.0);
    }

    printf("[Mailbox System] %d mailboxes loaded.", rows);
    return 1;
}


CMD:mailbox(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
        return SendClientErrorUnauthorizedCmd(playerid);

    new action[16], gangid;
    if(sscanf(params, "s[16]D(-1)", action, gangid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /mailbox [create/edit/remove/goto] [gangid(mailboxid)]");
    }

    // goto
    if(!strcmp(action, "goto", true))
    {
        if(gangid == -1 || gangid >= MAX_GANGS || MailboxInfo[gangid][mObjectID] == 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid mailbox ID.");
        }

        SetPlayerPos(playerid, MailboxInfo[gangid][mPosX], MailboxInfo[gangid][mPosY], MailboxInfo[gangid][mPosZ] + 1.0);
        SendClientMessageEx(playerid, COLOR_AQUA, "Teleported to %s mailbox.", GangInfo[gangid][gName]);
        return 1;
    }

    // Check if gang ID exists
    if(gangid < 0 || gangid >= MAX_GANGS || strlen(GangInfo[gangid][gName]) == 0)
        return SendClientMessage(playerid, COLOR_GREY, "This gang ID does not exist on the server.");

    // CREATE
    if(!strcmp(action, "create", true))
    {
        /*
            Displayed at the moment (Bugged)
        
        if(MailboxInfo[gangid][mGangID] == GangInfo[gangid][gIsMafia])
        {
            //return SendClientMessage(playerid, COLOR_GREY, "You cannot create mailbox for Mafia.");
        }*/
        
        if(MailboxInfo[gangid][mObjectID] != 0)
        {
            return SendClientMessage(playerid, COLOR_GREY, "This gang already has a mailbox.");
        }

        new Float:x, Float:y, Float:z;
        new Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0;
        GetPlayerPos(playerid, x, y, z);

        new objectid = CreateDynamicObject(MAILBOX_OBJECT_BOX, x, y, z, rx, ry, rz);
        EditDynamicObject(playerid, objectid);

        new gangName[64], color;
        color = GangInfo[gangid][gColor];
        format(gangName, sizeof gangName, "{%06x}%s's mailbox\n(( /openmailbox ))",color >>> 8, GangInfo[gangid][gName]);

        MailboxInfo[gangid][mLabelID] = CreateDynamic3DTextLabel(gangName, -1, x, y, z + 1.0, 15.0);

        MailboxInfo[gangid][mGangID] = gangid;
        MailboxInfo[gangid][mObjectID] = objectid;
        MailboxInfo[gangid][mRotX] = rx;
        MailboxInfo[gangid][mRotY] = ry;
        MailboxInfo[gangid][mRotZ] = rz;

        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has created a mailbox (ID %d) for %s.", GetAdmCmdRank(playerid), GetRPName(playerid), gangid, GangInfo[gangid][gName]);
        
        new query[256];
        mysql_format(connectionID, query, sizeof query,
            "INSERT INTO mailboxes (gang_id, posX, posY, posZ, rotX, rotY, rotZ, modelid) \
             VALUES (%d, %f, %f, %f, %f, %f, %f, %d)",
            gangid, x, y, z, rx, ry, rz, MAILBOX_OBJECT_BOX);
        mysql_tquery(connectionID, query);
    }

    // EDIT
    else if(!strcmp(action, "edit", true))
    {
        if(MailboxInfo[gangid][mObjectID] == 0)
            return SendClientMessage(playerid, COLOR_GREY, "This gang has no mailbox to edit.");

        EditDynamicObject(playerid, MailboxInfo[gangid][mObjectID]);
    }

    // REMOVE
    else if(!strcmp(action, "remove", true))
    {
        if(MailboxInfo[gangid][mObjectID] == 0)
            return SendClientMessage(playerid, COLOR_GREY, "This gang has no mailbox to remove.");

        DestroyDynamicObject(MailboxInfo[gangid][mObjectID]);
        if(MailboxInfo[gangid][mLabelID] != Text3D:INVALID_3DTEXT_ID)
            DestroyDynamic3DTextLabel(MailboxInfo[gangid][mLabelID]);

        MailboxInfo[gangid][mObjectID] = 0;
        MailboxInfo[gangid][mLabelID] = Text3D:INVALID_3DTEXT_ID;

        new query[256];
        mysql_format(connectionID, query, sizeof query, "DELETE FROM mailboxes WHERE gang_id=%d", gangid);
        mysql_tquery(connectionID, query);

        mysql_format(connectionID, query, sizeof query, "DELETE FROM mails WHERE gang_id=%d", gangid);
        mysql_tquery(connectionID, query);


        SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has removed mailbox (ID %d) for %s.", GetAdmCmdRank(playerid), GetRPName(playerid), gangid, GangInfo[gangid][gName]);
    }

    else
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /mailbox [create/edit/remove/goto] [gangid(mailboxid)");
    }

    return 1;
}

hook OP_EditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(response == EDIT_RESPONSE_FINAL)
    {
        for(new g = 0; g < MAX_GANGS; g++)
        {
            if(MailboxInfo[g][mObjectID] == objectid)
            {
                MailboxInfo[g][mPosX] = x;
                MailboxInfo[g][mPosY] = y;
                MailboxInfo[g][mPosZ] = z;
                MailboxInfo[g][mRotX] = rx;
                MailboxInfo[g][mRotY] = ry;
                MailboxInfo[g][mRotZ] = rz;

                DestroyDynamicObject(objectid);
                MailboxInfo[g][mObjectID] = CreateDynamicObject(MAILBOX_OBJECT_BOX, x, y, z, rx, ry, rz);

                new query[256];
                mysql_format(connectionID, query, sizeof query,
                    "UPDATE mailboxes SET posX=%f, posY=%f, posZ=%f, rotX=%f, rotY=%f, rotZ=%f WHERE gang_id=%d",
                    x, y, z, rx, ry, rz, g);
                mysql_tquery(connectionID, query);

                if(MailboxInfo[g][mLabelID] != Text3D:INVALID_3DTEXT_ID)
                    DestroyDynamic3DTextLabel(MailboxInfo[g][mLabelID]);

		        new gangName[64], color;
		        color = GangInfo[g][gColor];
		        format(gangName, sizeof gangName, "{%06x}%s's mailbox\n(( /openmailbox ))",color >>> 8, GangInfo[g][gName]);

                MailboxInfo[g][mLabelID] = CreateDynamic3DTextLabel(gangName, -1, x, y, z + 1.0, 15.0);
                break;
            }
        }
    }
    else if(response == EDIT_RESPONSE_CANCEL)
    {
        DestroyDynamicObject(objectid);
    }
    return 1;
}

new pTempGang[MAX_PLAYERS];
new pTempTitle[MAX_PLAYERS][64];  
new pTempBody[MAX_PLAYERS][256];

CMD:sendmail(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];
    if(gangid == -1 || !GangInfo[gangid][gIsMafia] || PlayerData[playerid][pGangRank] < 5)
        return SendClientMessage(playerid, COLOR_GREY, "Only Mafia members with rank 5+ can send mails!");

    new targetGang = -1;
    for(new g = 0; g < MAX_GANGS; g++)
    {
        if(MailboxInfo[g][mObjectID] != 0)
        {
            if(IsPlayerInRangeOfPoint(playerid, MAILBOX_RANGE, MailboxInfo[g][mPosX], MailboxInfo[g][mPosY], MailboxInfo[g][mPosZ]))
            {
                targetGang = g;
                break;
            }
        }
    }
    if(targetGang == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You must be near a gang mailbox to send mail!");

    pTempGang[playerid] = targetGang;

    Dialog_Show(playerid, DIALOG_SENDMAIL_TITLE, DIALOG_STYLE_INPUT, "Send Mail - Title", "Enter the title of your mail:", "Next", "Cancel");
    return 1;
}


Dialog:DIALOG_SENDMAIL_TITLE(playerid, response, listitem, inputtext[])
{
    if(!response) return 1; // Cancel pressed

    format(pTempTitle[playerid], 64, "%s", inputtext);

    Dialog_Show(playerid, DIALOG_SENDMAIL_BODY, DIALOG_STYLE_INPUT, "Send Mail - Body", "Enter the body of your mail:", "Next", "Cancel");
    return 1;
}

Dialog:DIALOG_SENDMAIL_BODY(playerid, response, listitem, inputtext[])
{
    if(!response) return 1; // Cancel pressed
	new str[658];
	format(pTempBody[playerid], 456, "%s", inputtext);
	format(str, sizeof str, "Are you sure you want to send this mail?\n\nTitle: %s\nBody: %s", pTempTitle[playerid], pTempBody[playerid]);

    Dialog_Show(playerid, DIALOG_SENDMAIL_CONFIRM, DIALOG_STYLE_MSGBOX, "Send Mail - Confirm", str, "Send", "Cancel");
    return 1;
}

Dialog:DIALOG_SENDMAIL_CONFIRM(playerid, response, listitem, inputtext[])
{
    if(!response) return 1; // Cancel pressed

    new pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof pname);

    new query[512];
    mysql_format(connectionID, query, sizeof query,
        "INSERT INTO mails (gang_id, sender_name, title, body) VALUES (%d, '%e', '%e', '%e')",
        pTempGang[playerid], pname, pTempTitle[playerid], pTempBody[playerid]);
    mysql_tquery(connectionID, query);
    
    SendClientMessage(playerid, COLOR_AQUA, "The mail sent successfully!");

    pTempGang[playerid] = -1;
    pTempTitle[playerid][0] = '\0';
    pTempBody[playerid][0] = '\0';
    return 1;
}

// =============== OPEN MAILBOX ===============
CMD:openmailbox(playerid, params[])
{
    new gangid = PlayerData[playerid][pGang];
    if(gangid == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You are not apart of any gang at the moment.");

    if(PlayerData[playerid][pGangRank] < 5)
        return SendClientMessage(playerid, COLOR_GREY, "You need to be at least rank 5+ to use this command.");

    if(MailboxInfo[gangid][mObjectID] == 0)
        return SendClientMessage(playerid, COLOR_GREY, "Your gang dont have any mailbox.");

    if(!IsPlayerInRangeOfPoint(playerid, MAILBOX_RANGE,
        MailboxInfo[gangid][mPosX],
        MailboxInfo[gangid][mPosY],
        MailboxInfo[gangid][mPosZ]))
        return SendClientMessage(playerid, COLOR_GREY, "You must be near your mailbox to open it.");
        
        
    ShowActionBubble(playerid, "* %s opens mailbox.", GetRPName(playerid));

    new query[128];
    mysql_format(connectionID, query, sizeof query,
        "SELECT id, sender_name, title, send_time FROM mails WHERE gang_id=%d ORDER BY id DESC LIMIT 10", gangid);
    mysql_tquery(connectionID, query, "OnMailboxList", "i", playerid);
    return 1;
}

forward OnMailboxList(playerid);
public OnMailboxList(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields);

    if (!rows)
        return SendClientMessage(playerid, COLOR_GREY, "No mails found.");

    new buffer[1024], sender[24], title[64], timeStr[32];
    buffer[0] = EOS;

    for (new i; i < rows; i++)
    {
        cache_get_field_content(i, "sender_name", sender);
        cache_get_field_content(i, "title", title);
        cache_get_field_content(i, "send_time", timeStr);

        new temp[128];
        format(temp, sizeof temp, "{FFFFFF}[%s] %s", timeStr, title);
        format(buffer, sizeof buffer, "%s%s\n", buffer, temp);
    }

    strcpy(MailListCache[playerid], buffer);
    MailListCount[playerid] = rows;

    Dialog_Show(playerid, MailboxList, DIALOG_STYLE_LIST, "Gang Mailbox", buffer, "Read", "Close");
    return 1;
}

Dialog:MailboxList(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;
    if(listitem >= MailListCount[playerid]) return 1;

    new gangid = PlayerData[playerid][pGang];
    new query[128];
    mysql_format(connectionID, query, sizeof query,
        "SELECT sender_name, title, body, send_time FROM mails WHERE gang_id=%d ORDER BY id DESC LIMIT 1 OFFSET %d",
        gangid, listitem);
    mysql_tquery(connectionID, query, "OnReadMail", "i", playerid);
    return 1;
}

forward OnReadMail(playerid);
public OnReadMail(playerid)
{
    if(!cache_num_rows())
        return SendClientMessage(playerid, COLOR_GREY, "Mail not found.");

    new sender[24], title[64], body[256], timeStr[32];
    cache_get_field_content(0, "sender_name", sender);
    cache_get_field_content(0, "title", title);
    cache_get_field_content(0, "body", body);
    cache_get_field_content(0, "send_time", timeStr);
    
    new msg[512];
    format(msg, sizeof msg, "{00AA00}From:{FFFFFF} %s\n{00AA00}Title:{FFFFFF} %s\n{00AA00}Date:{FFFFFF} %s\n\n%s", sender, title, timeStr, body);
    Dialog_Show(playerid, MailboxDetail, DIALOG_STYLE_MSGBOX, "Mail Details", msg, "Close", "");
    return 1;
}

Dialog:MailboxDetail(playerid, response, listitem, inputtext[])
{
    return 1;
}

CMD:clearmails(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
        return SendClientErrorUnauthorizedCmd(playerid);

    mysql_tquery(connectionID, "TRUNCATE TABLE mails");
    
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has cleared all mails", GetAdmCmdRank(playerid), GetRPName(playerid));
    SendClientMessage(playerid, COLOR_AQUA, "All mails have been cleared from the database.");
    return 1;
}

CMD:clearmailboxes(playerid, params[])
{
    if(!IsGodAdmin(playerid) && !PlayerData[playerid][pGangMod])
        return SendClientErrorUnauthorizedCmd(playerid);

    for(new g = 0; g < MAX_GANGS; g++)
    {
        if(MailboxInfo[g][mObjectID] != 0)
        {
            DestroyDynamicObject(MailboxInfo[g][mObjectID]);
            MailboxInfo[g][mObjectID] = 0;
        }
        if(MailboxInfo[g][mLabelID] != Text3D:INVALID_3DTEXT_ID)
        {
            DestroyDynamic3DTextLabel(MailboxInfo[g][mLabelID]);
            MailboxInfo[g][mLabelID] = Text3D:INVALID_3DTEXT_ID;
        }
    }

    mysql_tquery(connectionID, "TRUNCATE TABLE mailboxes");
    SendAdminMessage(COLOR_LIGHTRED, "AdmCmd: %s %s has cleared all mailboxes", GetAdmCmdRank(playerid), GetRPName(playerid));
    return 1;
}


