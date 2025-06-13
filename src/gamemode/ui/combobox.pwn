enum WidgetType
{
    WidgetType_Invalid,
    WidgetType_Window,
    WidgetType_Panel,
    WidgetType_Label,
    WidgetType_CheckBox,
    WidgetType_Button
};

enum TextAlignment
{
    TextAlignment_Left   = 1,
    TextAlignment_Center = 2,
    TextAlignment_Right  = 3
};

enum Font
{
    Font_GangTag,
    Font_Regular,
    Font_Light,
    Font_Bold,
    Font_Hidden
}

enum eWidget
{
    Widget_Name,
    Widget_Type,
    Float:Widget_PosX,
    Float:Widget_PosY,
    Widget_Color,
    Widget_Background,
    Widget_Enabled,
    Widget_Visible,
    Widget_Children[5]
};
#define MAX_PLAYER_WIDGETS 20

static Widgets[MAX_PLAYERS][MAX_PLAYER_WIDGETS][eWidget];

GetPlayerNewWidgetId(playerid)
{
    for (new idx = 0; idx < MAX_PLAYER_WIDGETS; idx++)
    {
        if (Widgets[playerid][idx][Widget_Type] != WidgetType_Invalid)
        {
            return idx;
        }
    }
    return -1;
}

CreateLabel(playerid, title, Float:x, Float:y, const text[], fontsize = 10, color = -1, background = 255)
{
    new newId = GetPlayerNewWidgetId(playerid);
    if (newId == -1)
        return -1;
    Widgets[playerid][newId][Widget_Type] = WidgetType_Label;
    new label = CreatePlayerTextDraw(playerid, x, y, text);
    PlayerTextDrawBackgroundColor(playerid, label, background);
    PlayerTextDrawColor(playerid, label, color);
    PlayerTextDrawAlignment(playerid, label, _:TextAlignment_Left);
    PlayerTextDrawFont(playerid, label, _:Font_Regular);
    PlayerTextDrawLetterSize(playerid, label, fontsize * 0.0260, fontsize * 0.1300);
    PlayerTextDrawSetOutline(playerid, label, 1);
    PlayerTextDrawSetProportional(playerid, label, 1);
    Widgets[playerid][newId][Widget_Children][0] = label;
    return newId;

}

CreateCombobox(playerid, title, Float:x, Float:y, value = false, color, background)
{

}

DeleteWidget(playerid, id)
{
    if (id < 0 || id >= MAX_PLAYER_WIDGETS)
        return;

    switch (Widgets[playerid][id][Widget_Type])
    {
        case WidgetType_Label:
        {
            PlayerTextDrawDestroy(playerid, Widgets[playerid][newId][Widget_Children][0]);
        }
    }
    Widgets[playerid][id][Widget_Type] = WidgetType_Invalid;
}

SetWidgetColor(playerid, id, color);
SetWidgetBackgroundColor(playerid, id, backgroundColor);
SetWidgetFont(playerid, id, font);
SetWidgetPosition(playerid, id, Float:x, Float:y);
SetWidgetClickable(playerid, id, value);
SetWidgetEnabled(playerid, id, value);
ShowWidget(playerid, id);
HideWidget(playerid, id);
