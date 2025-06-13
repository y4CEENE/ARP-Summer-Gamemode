#include <YSI\y_hooks>

static GraphicDesigner[MAX_PLAYERS];

hook OnPlayerInit(playerid)
{
    GraphicDesigner[playerid] = 0;
}

hook OnLoadPlayer(playerid, row)
{
    GraphicDesigner[playerid] = GetDBIntField(row, "graphic");
}

stock GetGraphicDesignerRank(playerid)
{
    return GraphicDesigner[playerid];
}

CMD:graphichelp(playerid, params[])
{
    if (GraphicDesigner[playerid] > 0)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "____________________________________________");
        if (GraphicDesigner[playerid] == GRAPHICRANK_REGULAR)
        {
            SendClientMessage(playerid, COLOR_WHITE, "*1* Graphics Designer: /(g)raphic(c)hat /designers");
        }
        else if (GraphicDesigner[playerid] == GRAPHICRANK_EDITOR)
        {
            SendClientMessage(playerid, COLOR_WHITE, "*2* Video Editor: /(g)raphic(c)hat /designers /ibelieveicanfly");
        }
        else if (GraphicDesigner[playerid] == GRAPHICRANK_MANAGER)
        {
            SendClientMessage(playerid, COLOR_WHITE, "*3* Graphic Manager: /(g)raphic(c)hat /designers /ibelieveicanfly /makedesigner");
        }
    }
    else
    {
        return SendUnauthorized(playerid);
    }
    return 1;
}

CMD:makedesigner(playerid, params[])
{
    if (GraphicDesigner[playerid] < GRAPHICRANK_MANAGER && !IsAdmin(playerid, ADMIN_LVL_10))
    {
        return SendUnauthorized(playerid);
    }
    new targetid, rank[24], str[128];
    if (sscanf(params, "us[24]", targetid, rank))
    {
        SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /makedesigner [playerid] [rank]");
        SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} 'None' 'Regular' 'Editor' or 'Manager'");
        return 1;
    }
    if (!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "{FF0000}Error:{FFFFFF} That player isn't connected.");
    }
    if (strcmp(rank, "none", true) == 0)
    {
        SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has removed %s's status as a Designer.", GetRPName(playerid), GetRPName(targetid));
        SendClientMessage(targetid, COLOR_AQUA, "You are no longer a Designer.");
        GraphicDesigner[targetid] = GRAPHICRANK_NONE;
        format(str, sizeof(str), "You removed %s from the Designer team.", GetRPName(targetid));
        SendClientMessage(playerid, COLOR_AQUA, str);
        return 1;
    }
    else if (strcmp(rank, "regular", true) == 0)
    {
        GraphicDesigner[targetid] = GRAPHICRANK_REGULAR;
        format(str, sizeof(str), "You have been given the status of a %s Designer.", rank);
        SendClientMessage(targetid, COLOR_AQUA, str);
        SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has been given the status of a %s Designer by %s", GetRPName(targetid), rank, GetRPName(playerid));
        format(str, sizeof(str), "You gave %s the status of a %s Designer.", GetRPName(targetid), rank);
        SendClientMessage(playerid, COLOR_AQUA, str);
    }
    else if (strcmp(rank, "editor", true) == 0)
    {
        GraphicDesigner[targetid] = GRAPHICRANK_EDITOR;
        format(str, sizeof(str), "You have been given the status of a %s Designer.", rank);
        SendClientMessage(targetid, COLOR_AQUA, str);
        SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has been given the status of a %s Designer by %s", GetRPName(targetid), rank, GetRPName(playerid));
        format(str, sizeof(str), "You gave %s the status of a %s Designer.", GetRPName(targetid), rank);
        SendClientMessage(playerid, COLOR_AQUA, str);
    }
    else if (strcmp(rank, "manager", true) == 0)
    {
        GraphicDesigner[targetid] = GRAPHICRANK_MANAGER;
        format(str, sizeof(str), "You have been given the status of a %s Designer.", rank);
        SendClientMessage(targetid, COLOR_AQUA, str);
        SendAdminMessage(COLOR_YELLOW, "{FF0000}AdmWarning{FFFFFF}: %s has been given the status of a %s Designer by %s", GetRPName(targetid), rank, GetRPName(playerid));
        format(str, sizeof(str), "You gave %s the status of a %s Designer.", GetRPName(targetid), rank);
        SendClientMessage(playerid, COLOR_AQUA, str);
    }
    else
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid rank specified.");
    }
    DBQuery("UPDATE "#TABLE_USERS" SET graphic = %i WHERE uid = %i", GraphicDesigner[targetid], PlayerData[targetid][pID]);
    return 1;
}

CMD:graphicchat(playerid, params[])
{
    if (GraphicDesigner[playerid] >= 1)
    {
        new msg[128];
        new str[128];
        if (!sscanf(params, "s[128]", msg))
        {
            if (GraphicDesigner[playerid] == GRAPHICRANK_REGULAR) str = "Graphics Designer";
            else if (GraphicDesigner[playerid] == GRAPHICRANK_EDITOR) str = "Video Editor";
            else if (GraphicDesigner[playerid] == GRAPHICRANK_MANAGER) str = "Graphic Manager";

            format(str, sizeof(str), "* %s %s: %s *", str, GetRPName(playerid), msg);
            SendGraphicMessage(0xFA58ACFF, str);
        }
        else
        {
            SendClientMessage(playerid, COLOR_GREY, "{00BFFF}Usage:{FFFFFF} /(g)raphic(c)hat [message]");
        }
    }
    else
    {
        return SendUnautorizedChat(playerid);
    }
    return 1;
}

SendGraphicMessage(color, string2[])
{
    foreach(new i : Player)
    {
        if (IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if (GraphicDesigner[i] >= 1 || IsAdmin(i, ADMIN_LVL_5))
            {
                SendClientMessage(i, color, string2);
            }
        }
    }
}
