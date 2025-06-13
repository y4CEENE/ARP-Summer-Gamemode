/// @file      MDC.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-04-01 23:54:04 +0100
/// @copyright Copyright (c) 2022

#include <YSI\y_hooks>

//DEFINE_HOOK_REPLACEMENT(OnPlayer, OP_);
// CONFIG:
#define MAX_CRIMINAL_RECORDS        50

enum {
    RECORD_TICKET,
    RECORD_CHARGE
}

static Text:MdcGui_Box = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_HeaderBox = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_CitizenBox = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_DataBox = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_OptionsBox = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_HeaderText = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Exit = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Section[4] = {Text:INVALID_TEXT_DRAW, ...};
static Text:MdcGui_SectionText[4] = {Text:INVALID_TEXT_DRAW, ...};
static Text:MdcGui_SectionHeaderText = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Gender = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Job = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_DriveLic = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_GunLic = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_PhoneNumber = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Name = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_PropertiesArrow = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_VehiclesArrow = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Vehicles = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Properties = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Age = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_CriminalRecordArrow = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_CasesArrow = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_CriminalRecord = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Cases = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_Browse = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_Box[7] = {Text:INVALID_TEXT_DRAW, ...};
static Text:MdcGui_cr_InnerBox[7] = {Text:INVALID_TEXT_DRAW, ...};
static Text:MdcGui_cr_TypeTitle = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_DescriptionTitle = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_DateTitle = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_Title = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_ArrowUp = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_ArrowDown = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_cr_Info[7] = {Text:INVALID_TEXT_DRAW, ...};
static Text:MdcGui_veh_Box = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_InnerBox = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_Model = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_Owner = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_Plate = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_Insurance = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_ArrowRight = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_Next = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_Label = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_BoxNoEnt = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_InnerBoxNoEnt = Text:INVALID_TEXT_DRAW;
static Text:MdcGui_veh_TextNoEnt = Text:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_Skin = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_NameValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_AgeValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_GenderValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_JobValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_DriveLicValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_GunLicValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_PhoneNumberValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_cr_Type[7] = {PlayerText:INVALID_TEXT_DRAW, ...};
static PlayerText:MdcGui_cr_Description[7] = {PlayerText:INVALID_TEXT_DRAW, ...};
static PlayerText:MdcGui_cr_Date[7] = {PlayerText:INVALID_TEXT_DRAW, ...};
static PlayerText:MdcGui_veh_ModelValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_veh_VehicleModel = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_veh_OwnerValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_veh_PlateValue = PlayerText:INVALID_TEXT_DRAW;
static PlayerText:MdcGui_veh_InsuranceValue = PlayerText:INVALID_TEXT_DRAW;

enum CriminalRecordEnum {
    CR_Type,
    CR_Description[200],
    CR_Date[15],
    CR_Time[15],
    CR_Officer[MAX_PLAYER_NAME],
    CR_Offender[MAX_PLAYER_NAME],
    CR_Paid,
    CR_Price,
    CR_Served
};
static Iterator:RecordIterator[MAX_PLAYERS]<MAX_CRIMINAL_RECORDS>;

static CriminalRecordData[MAX_PLAYERS][MAX_CRIMINAL_RECORDS][CriminalRecordEnum];

static Float:mdc_coordinates[][] = {
    {1563.4691,-1660.4598,2110.5366},
    {1559.6234,-1669.4209,2110.5361},
    {-506.1294,316.9367,2004.5859},
    {1169.9800, 2971.7549, 1005.3100},  // Precinct
    {1763.2000, -1658.7200, 1109.5100}  // FBIhq
};

hook OnScriptInit()
{
	Iter_Init(RecordIterator);
}

hook OnPlayerInit(playerid)
{
    mdc_LoadPlayerTextdraws(playerid);
    return 1;
}
hook OnGameModeInit()
{

    MdcGui_Box = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_Box, 255);
    TextDrawFont(MdcGui_Box, 1);
    TextDrawLetterSize(MdcGui_Box, 0.000000, 6.399999);
    TextDrawColor(MdcGui_Box, -1);
    TextDrawSetOutline(MdcGui_Box, 0);
    TextDrawSetProportional(MdcGui_Box, 1);
    TextDrawSetShadow(MdcGui_Box, 1);
    TextDrawUseBox(MdcGui_Box, 1);
    TextDrawBoxColor(MdcGui_Box, 125);
    TextDrawTextSize(MdcGui_Box, 198.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_Box, 0);

    MdcGui_HeaderBox = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_HeaderBox, 255);
    TextDrawFont(MdcGui_HeaderBox, 1);
    TextDrawLetterSize(MdcGui_HeaderBox, 0.000000, 1.799998);
    TextDrawColor(MdcGui_HeaderBox, -1);
    TextDrawSetOutline(MdcGui_HeaderBox, 0);
    TextDrawSetProportional(MdcGui_HeaderBox, 1);
    TextDrawSetShadow(MdcGui_HeaderBox, 1);
    TextDrawUseBox(MdcGui_HeaderBox, 1);
    TextDrawBoxColor(MdcGui_HeaderBox, 100);
    TextDrawTextSize(MdcGui_HeaderBox, 198.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_HeaderBox, 0);

    MdcGui_CitizenBox = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_CitizenBox, 255);
    TextDrawFont(MdcGui_CitizenBox, 1);
    TextDrawLetterSize(MdcGui_CitizenBox, 0.000000, 11.699997);
    TextDrawColor(MdcGui_CitizenBox, -1);
    TextDrawSetOutline(MdcGui_CitizenBox, 0);
    TextDrawSetProportional(MdcGui_CitizenBox, 1);
    TextDrawSetShadow(MdcGui_CitizenBox, 1);
    TextDrawUseBox(MdcGui_CitizenBox, 1);
    TextDrawBoxColor(MdcGui_CitizenBox, 125);
    TextDrawTextSize(MdcGui_CitizenBox, 198.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_CitizenBox, 0);

    MdcGui_DataBox = TextDrawCreate(432.000000, 223.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_DataBox, 255);
    TextDrawFont(MdcGui_DataBox, 1);
    TextDrawLetterSize(MdcGui_DataBox, 0.000000, 5.199998);
    TextDrawColor(MdcGui_DataBox, -1);
    TextDrawSetOutline(MdcGui_DataBox, 0);
    TextDrawSetProportional(MdcGui_DataBox, 1);
    TextDrawSetShadow(MdcGui_DataBox, 1);
    TextDrawUseBox(MdcGui_DataBox, 1);
    TextDrawBoxColor(MdcGui_DataBox, 125);
    TextDrawTextSize(MdcGui_DataBox, 255.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_DataBox, 0);

    MdcGui_OptionsBox = TextDrawCreate(432.000000, 329.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_OptionsBox, 255);
    TextDrawFont(MdcGui_OptionsBox, 1);
    TextDrawLetterSize(MdcGui_OptionsBox, 0.000000, 2.699999);
    TextDrawColor(MdcGui_OptionsBox, -1);
    TextDrawSetOutline(MdcGui_OptionsBox, 0);
    TextDrawSetProportional(MdcGui_OptionsBox, 1);
    TextDrawSetShadow(MdcGui_OptionsBox, 1);
    TextDrawUseBox(MdcGui_OptionsBox, 1);
    TextDrawBoxColor(MdcGui_OptionsBox, 125);
    TextDrawTextSize(MdcGui_OptionsBox, 208.000000, -70.000000);
    TextDrawSetSelectable(MdcGui_OptionsBox, 0);

    for (new i = 0; i < sizeof(MdcGui_cr_Box); i++)
    {
        MdcGui_cr_Box[i] = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
        TextDrawBackgroundColor(MdcGui_cr_Box[i], 255);
        TextDrawFont(MdcGui_cr_Box[i], 1);
        TextDrawLetterSize(MdcGui_cr_Box[i], 0.000000, 5.4999 + i * 0.8167);
        TextDrawColor(MdcGui_cr_Box[i], -1);
        TextDrawSetOutline(MdcGui_cr_Box[i], 0);
        TextDrawSetProportional(MdcGui_cr_Box[i], 1);
        TextDrawSetShadow(MdcGui_cr_Box[i], 1);
        TextDrawUseBox(MdcGui_cr_Box[i], 1);
        TextDrawBoxColor(MdcGui_cr_Box[i], 125);
        TextDrawTextSize(MdcGui_cr_Box[i], 198.000000, 0.000000);
        TextDrawSetSelectable(MdcGui_cr_Box[i], 0);
    }

    for (new i = 0; i < sizeof(MdcGui_cr_InnerBox); i++)
    {
        MdcGui_cr_InnerBox[i] = TextDrawCreate(432.000000, 228.000000, "New Textdraw");
        TextDrawBackgroundColor(MdcGui_cr_InnerBox[i], 255);
        TextDrawFont(MdcGui_cr_InnerBox[i], 1);
        TextDrawLetterSize(MdcGui_cr_InnerBox[i], 0.000000, 2.0999 + i * 0.8167);
        TextDrawColor(MdcGui_cr_InnerBox[i], -1);
        TextDrawSetOutline(MdcGui_cr_InnerBox[i], 0);
        TextDrawSetProportional(MdcGui_cr_InnerBox[i], 1);
        TextDrawSetShadow(MdcGui_cr_InnerBox[i], 1);
        TextDrawUseBox(MdcGui_cr_InnerBox[i], 1);
        TextDrawBoxColor(MdcGui_cr_InnerBox[i], 100);
        TextDrawTextSize(MdcGui_cr_InnerBox[i], 208.000000, 0.000000);
        TextDrawSetSelectable(MdcGui_cr_InnerBox[i], 1);
    }

    MdcGui_veh_Box = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_veh_Box, 255);
    TextDrawFont(MdcGui_veh_Box, 1);
    TextDrawLetterSize(MdcGui_veh_Box, 0.000000, 6.299985);
    TextDrawColor(MdcGui_veh_Box, -1);
    TextDrawSetOutline(MdcGui_veh_Box, 0);
    TextDrawSetProportional(MdcGui_veh_Box, 1);
    TextDrawSetShadow(MdcGui_veh_Box, 1);
    TextDrawUseBox(MdcGui_veh_Box, 1);
    TextDrawBoxColor(MdcGui_veh_Box, 125);
    TextDrawTextSize(MdcGui_veh_Box, 198.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_veh_Box, 0);

    MdcGui_veh_InnerBox = TextDrawCreate(432.000000, 223.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_veh_InnerBox, 255);
    TextDrawFont(MdcGui_veh_InnerBox, 1);
    TextDrawLetterSize(MdcGui_veh_InnerBox, 0.000000, 3.199998);
    TextDrawColor(MdcGui_veh_InnerBox, -1);
    TextDrawSetOutline(MdcGui_veh_InnerBox, 0);
    TextDrawSetProportional(MdcGui_veh_InnerBox, 1);
    TextDrawSetShadow(MdcGui_veh_InnerBox, 1);
    TextDrawUseBox(MdcGui_veh_InnerBox, 1);
    TextDrawBoxColor(MdcGui_veh_InnerBox, 100);
    TextDrawTextSize(MdcGui_veh_InnerBox, 255.000000, -10.000000);
    TextDrawSetSelectable(MdcGui_veh_InnerBox, 1);

    MdcGui_veh_BoxNoEnt = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_veh_BoxNoEnt, 255);
    TextDrawFont(MdcGui_veh_BoxNoEnt, 1);
    TextDrawLetterSize(MdcGui_veh_BoxNoEnt, 0.000000, 4.199985);
    TextDrawColor(MdcGui_veh_BoxNoEnt, -1);
    TextDrawSetOutline(MdcGui_veh_BoxNoEnt, 0);
    TextDrawSetProportional(MdcGui_veh_BoxNoEnt, 1);
    TextDrawSetShadow(MdcGui_veh_BoxNoEnt, 1);
    TextDrawUseBox(MdcGui_veh_BoxNoEnt, 1);
    TextDrawBoxColor(MdcGui_veh_BoxNoEnt, 125);
    TextDrawTextSize(MdcGui_veh_BoxNoEnt, 198.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_veh_BoxNoEnt, 0);

    MdcGui_veh_InnerBoxNoEnt = TextDrawCreate(432.000000, 223.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_veh_InnerBoxNoEnt, 255);
    TextDrawFont(MdcGui_veh_InnerBoxNoEnt, 1);
    TextDrawLetterSize(MdcGui_veh_InnerBoxNoEnt, 0.000000, 1.199998);
    TextDrawColor(MdcGui_veh_InnerBoxNoEnt, -1);
    TextDrawSetOutline(MdcGui_veh_InnerBoxNoEnt, 0);
    TextDrawSetProportional(MdcGui_veh_InnerBoxNoEnt, 1);
    TextDrawSetShadow(MdcGui_veh_InnerBoxNoEnt, 1);
    TextDrawUseBox(MdcGui_veh_InnerBoxNoEnt, 1);
    TextDrawBoxColor(MdcGui_veh_InnerBoxNoEnt, 100);
    TextDrawTextSize(MdcGui_veh_InnerBoxNoEnt, 255.000000, -10.000000);
    TextDrawSetSelectable(MdcGui_veh_InnerBoxNoEnt, 1);

    MdcGui_veh_TextNoEnt = TextDrawCreate(267.000000, 228.000000, "No entries could be found.");
    TextDrawBackgroundColor(MdcGui_veh_TextNoEnt, 255);
    TextDrawFont(MdcGui_veh_TextNoEnt, 2);
    TextDrawLetterSize(MdcGui_veh_TextNoEnt, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_TextNoEnt, -1);
    TextDrawSetOutline(MdcGui_veh_TextNoEnt, 0);
    TextDrawSetProportional(MdcGui_veh_TextNoEnt, 1);
    TextDrawSetShadow(MdcGui_veh_TextNoEnt, 1);
    TextDrawSetSelectable(MdcGui_veh_TextNoEnt, 0);

    MdcGui_veh_Model = TextDrawCreate(329.000000, 228.000000, "~b~~h~~h~~h~Model Name:");
    TextDrawAlignment(MdcGui_veh_Model, 3);
    TextDrawBackgroundColor(MdcGui_veh_Model, 255);
    TextDrawFont(MdcGui_veh_Model, 2);
    TextDrawLetterSize(MdcGui_veh_Model, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_Model, -524057345);
    TextDrawSetOutline(MdcGui_veh_Model, 0);
    TextDrawSetProportional(MdcGui_veh_Model, 1);
    TextDrawSetShadow(MdcGui_veh_Model, 1);
    TextDrawSetSelectable(MdcGui_veh_Model, 0);

    MdcGui_veh_Owner = TextDrawCreate(329.000000, 240.000000, "~b~~h~~h~~h~Owner:");
    TextDrawAlignment(MdcGui_veh_Owner, 3);
    TextDrawBackgroundColor(MdcGui_veh_Owner, 255);
    TextDrawFont(MdcGui_veh_Owner, 2);
    TextDrawLetterSize(MdcGui_veh_Owner, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_Owner, -524057345);
    TextDrawSetOutline(MdcGui_veh_Owner, 0);
    TextDrawSetProportional(MdcGui_veh_Owner, 1);
    TextDrawSetShadow(MdcGui_veh_Owner, 1);
    TextDrawSetSelectable(MdcGui_veh_Owner, 0);

    MdcGui_veh_Plate = TextDrawCreate(329.000000, 252.000000, "~b~~h~~h~~h~License Plate:");
    TextDrawAlignment(MdcGui_veh_Plate, 3);
    TextDrawBackgroundColor(MdcGui_veh_Plate, 255);
    TextDrawFont(MdcGui_veh_Plate, 2);
    TextDrawLetterSize(MdcGui_veh_Plate, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_Plate, -524057345);
    TextDrawSetOutline(MdcGui_veh_Plate, 0);
    TextDrawSetProportional(MdcGui_veh_Plate, 1);
    TextDrawSetShadow(MdcGui_veh_Plate, 1);
    TextDrawSetSelectable(MdcGui_veh_Plate, 0);

    MdcGui_veh_Insurance = TextDrawCreate(329.000000, 264.000000, "~b~~h~~h~~h~Insurance:");
    TextDrawAlignment(MdcGui_veh_Insurance, 3);
    TextDrawBackgroundColor(MdcGui_veh_Insurance, 255);
    TextDrawFont(MdcGui_veh_Insurance, 2);
    TextDrawLetterSize(MdcGui_veh_Insurance, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_Insurance, -524057345);
    TextDrawSetOutline(MdcGui_veh_Insurance, 0);
    TextDrawSetProportional(MdcGui_veh_Insurance, 1);
    TextDrawSetShadow(MdcGui_veh_Insurance, 1);
    TextDrawSetSelectable(MdcGui_veh_Insurance, 0);

    MdcGui_veh_ArrowRight = TextDrawCreate(425.000000, 276.000000, "LD_BEAT:right");
    TextDrawBackgroundColor(MdcGui_veh_ArrowRight, 255);
    TextDrawFont(MdcGui_veh_ArrowRight, 4);
    TextDrawLetterSize(MdcGui_veh_ArrowRight, 0.500000, 1.000000);
    TextDrawColor(MdcGui_veh_ArrowRight, -1);
    TextDrawSetOutline(MdcGui_veh_ArrowRight, 0);
    TextDrawSetProportional(MdcGui_veh_ArrowRight, 1);
    TextDrawSetShadow(MdcGui_veh_ArrowRight, 1);
    TextDrawUseBox(MdcGui_veh_ArrowRight, 1);
    TextDrawBoxColor(MdcGui_veh_ArrowRight, 255);
    TextDrawTextSize(MdcGui_veh_ArrowRight, 10.000000, 12.000000);
    TextDrawSetSelectable(MdcGui_veh_ArrowRight, 1);

    MdcGui_veh_Next = TextDrawCreate(404.000000, 276.000000, "~b~~h~~h~~h~Next");
    TextDrawBackgroundColor(MdcGui_veh_Next, 255);
    TextDrawFont(MdcGui_veh_Next, 2);
    TextDrawLetterSize(MdcGui_veh_Next, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_Next, -1);
    TextDrawSetOutline(MdcGui_veh_Next, 0);
    TextDrawSetProportional(MdcGui_veh_Next, 1);
    TextDrawSetShadow(MdcGui_veh_Next, 1);
    TextDrawTextSize(MdcGui_veh_Next, 423.000000, 152.000000);
    TextDrawSetSelectable(MdcGui_veh_Next, 1);

    MdcGui_veh_Label = TextDrawCreate(254.000000, 217.000000, "~b~Vehicles");
    TextDrawBackgroundColor(MdcGui_veh_Label, 255);
    TextDrawFont(MdcGui_veh_Label, 2);
    TextDrawLetterSize(MdcGui_veh_Label, 0.170000, 1.000000);
    TextDrawColor(MdcGui_veh_Label, -1384438529);
    TextDrawSetOutline(MdcGui_veh_Label, 0);
    TextDrawSetProportional(MdcGui_veh_Label, 1);
    TextDrawSetShadow(MdcGui_veh_Label, 1);
    TextDrawSetPreviewModel(MdcGui_veh_Label, 480);
    TextDrawSetPreviewRot(MdcGui_veh_Label, -16.000000, 0.000000, -55.000000, 1.000000);
    TextDrawSetSelectable(MdcGui_veh_Label, 0);

    MdcGui_HeaderText = TextDrawCreate(209.000000, 189.000000, "~b~~h~Mobile Data Computer");
    TextDrawBackgroundColor(MdcGui_HeaderText, 255);
    TextDrawFont(MdcGui_HeaderText, 2);
    TextDrawLetterSize(MdcGui_HeaderText, 0.219999, 1.200000);
    TextDrawColor(MdcGui_HeaderText, -1384438529);
    TextDrawSetOutline(MdcGui_HeaderText, 0);
    TextDrawSetProportional(MdcGui_HeaderText, 1);
    TextDrawSetShadow(MdcGui_HeaderText, 1);
    TextDrawSetSelectable(MdcGui_HeaderText, 0);

    MdcGui_Exit = TextDrawCreate(420.000000, 189.000000, "LD_BEAT:cross");
    TextDrawBackgroundColor(MdcGui_Exit, 255);
    TextDrawFont(MdcGui_Exit, 4);
    TextDrawLetterSize(MdcGui_Exit, 0.500000, 1.000000);
    TextDrawColor(MdcGui_Exit, -1);
    TextDrawSetOutline(MdcGui_Exit, 0);
    TextDrawSetProportional(MdcGui_Exit, 1);
    TextDrawSetShadow(MdcGui_Exit, 1);
    TextDrawUseBox(MdcGui_Exit, 1);
    TextDrawBoxColor(MdcGui_Exit, 255);
    TextDrawTextSize(MdcGui_Exit, 10.000000, 12.000000);
    TextDrawSetSelectable(MdcGui_Exit, 1);

    MdcGui_Section[0] = TextDrawCreate(316.000000, 228.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_Section[0], 255);
    TextDrawFont(MdcGui_Section[0], 1);
    TextDrawLetterSize(MdcGui_Section[0], 0.000000, 1.199999);
    TextDrawColor(MdcGui_Section[0], -1);
    TextDrawSetOutline(MdcGui_Section[0], 0);
    TextDrawSetProportional(MdcGui_Section[0], 1);
    TextDrawSetShadow(MdcGui_Section[0], 1);
    TextDrawUseBox(MdcGui_Section[0], 1);
    TextDrawBoxColor(MdcGui_Section[0], 100);
    TextDrawTextSize(MdcGui_Section[0], 208.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_Section[0], 0);

    MdcGui_Section[1] = TextDrawCreate(316.000000, 257.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_Section[1], 255);
    TextDrawFont(MdcGui_Section[1], 1);
    TextDrawLetterSize(MdcGui_Section[1], 0.000000, 1.199999);
    TextDrawColor(MdcGui_Section[1], -1);
    TextDrawSetOutline(MdcGui_Section[1], 0);
    TextDrawSetProportional(MdcGui_Section[1], 1);
    TextDrawSetShadow(MdcGui_Section[1], 1);
    TextDrawUseBox(MdcGui_Section[1], 1);
    TextDrawBoxColor(MdcGui_Section[1], 100);
    TextDrawTextSize(MdcGui_Section[1], 208.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_Section[1], 0);

    MdcGui_Section[2] = TextDrawCreate(432.000000, 257.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_Section[2], 255);
    TextDrawFont(MdcGui_Section[2], 1);
    TextDrawLetterSize(MdcGui_Section[2], 0.000000, 1.199999);
    TextDrawColor(MdcGui_Section[2], -1);
    TextDrawSetOutline(MdcGui_Section[2], 0);
    TextDrawSetProportional(MdcGui_Section[2], 1);
    TextDrawSetShadow(MdcGui_Section[2], 1);
    TextDrawUseBox(MdcGui_Section[2], 1);
    TextDrawBoxColor(MdcGui_Section[2], 100);
    TextDrawTextSize(MdcGui_Section[2], 323.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_Section[2], 0);

    MdcGui_Section[3] = TextDrawCreate(432.000000, 228.000000, "New Textdraw");
    TextDrawBackgroundColor(MdcGui_Section[3], 255);
    TextDrawFont(MdcGui_Section[3], 1);
    TextDrawLetterSize(MdcGui_Section[3], 0.000000, 1.199999);
    TextDrawColor(MdcGui_Section[3], -1);
    TextDrawSetOutline(MdcGui_Section[3], 0);
    TextDrawSetProportional(MdcGui_Section[3], 1);
    TextDrawSetShadow(MdcGui_Section[3], 1);
    TextDrawUseBox(MdcGui_Section[3], 1);
    TextDrawBoxColor(MdcGui_Section[3], 100);
    TextDrawTextSize(MdcGui_Section[3], 323.000000, 0.000000);
    TextDrawSetSelectable(MdcGui_Section[3], 0);

    MdcGui_SectionText[0] = TextDrawCreate(262.000000, 234.000000, "~b~~h~~h~~h~Search Citizen");
    TextDrawAlignment(MdcGui_SectionText[0], 2);
    TextDrawBackgroundColor(MdcGui_SectionText[0], 255);
    TextDrawFont(MdcGui_SectionText[0], 2);
    TextDrawLetterSize(MdcGui_SectionText[0], 0.170000, 1.000000);
    TextDrawColor(MdcGui_SectionText[0], -524057345);
    TextDrawSetOutline(MdcGui_SectionText[0], 0);
    TextDrawSetProportional(MdcGui_SectionText[0], 1);
    TextDrawSetShadow(MdcGui_SectionText[0], 1);
    TextDrawTextSize(MdcGui_SectionText[0], 15.000000, 102.000000);
    TextDrawSetSelectable(MdcGui_SectionText[0], 1);

    MdcGui_SectionText[1] = TextDrawCreate(262.000000, 263.000000, "~b~~h~~h~~h~Search Weapon Serial");
    TextDrawAlignment(MdcGui_SectionText[1], 2);
    TextDrawBackgroundColor(MdcGui_SectionText[1], 255);
    TextDrawFont(MdcGui_SectionText[1], 2);
    TextDrawLetterSize(MdcGui_SectionText[1], 0.170000, 1.000000);
    TextDrawColor(MdcGui_SectionText[1], -524057345);
    TextDrawSetOutline(MdcGui_SectionText[1], 0);
    TextDrawSetProportional(MdcGui_SectionText[1], 1);
    TextDrawSetShadow(MdcGui_SectionText[1], 1);
    TextDrawTextSize(MdcGui_SectionText[1], 15.000000, 102.000000);
    TextDrawSetSelectable(MdcGui_SectionText[1], 1);

    MdcGui_SectionText[2] = TextDrawCreate(378.000000, 263.000000, "~b~~h~~h~~h~Search Phone Number");
    TextDrawAlignment(MdcGui_SectionText[2], 2);
    TextDrawBackgroundColor(MdcGui_SectionText[2], 255);
    TextDrawFont(MdcGui_SectionText[2], 2);
    TextDrawLetterSize(MdcGui_SectionText[2], 0.170000, 1.000000);
    TextDrawColor(MdcGui_SectionText[2], -524057345);
    TextDrawSetOutline(MdcGui_SectionText[2], 0);
    TextDrawSetProportional(MdcGui_SectionText[2], 1);
    TextDrawSetShadow(MdcGui_SectionText[2], 1);
    TextDrawTextSize(MdcGui_SectionText[2], 15.000000, 102.000000);
    TextDrawSetSelectable(MdcGui_SectionText[2], 1);

    MdcGui_SectionText[3] = TextDrawCreate(378.000000, 234.000000, "~b~~h~~h~~h~Search License Plate");
    TextDrawAlignment(MdcGui_SectionText[3], 2);
    TextDrawBackgroundColor(MdcGui_SectionText[3], 255);
    TextDrawFont(MdcGui_SectionText[3], 2);
    TextDrawLetterSize(MdcGui_SectionText[3], 0.170000, 1.000000);
    TextDrawColor(MdcGui_SectionText[3], -524057345);
    TextDrawSetOutline(MdcGui_SectionText[3], 0);
    TextDrawSetProportional(MdcGui_SectionText[3], 1);
    TextDrawSetShadow(MdcGui_SectionText[3], 1);
    TextDrawTextSize(MdcGui_SectionText[3], 15.000000, 103.000000);
    TextDrawSetSelectable(MdcGui_SectionText[3], 1);

    MdcGui_SectionHeaderText = TextDrawCreate(207.000000, 220.000000, "~b~Sections");
    TextDrawBackgroundColor(MdcGui_SectionHeaderText, 255);
    TextDrawFont(MdcGui_SectionHeaderText, 2);
    TextDrawLetterSize(MdcGui_SectionHeaderText, 0.170000, 1.000000);
    TextDrawColor(MdcGui_SectionHeaderText, -1384438529);
    TextDrawSetOutline(MdcGui_SectionHeaderText, 0);
    TextDrawSetProportional(MdcGui_SectionHeaderText, 1);
    TextDrawSetShadow(MdcGui_SectionHeaderText, 1);
    TextDrawSetSelectable(MdcGui_SectionHeaderText, 0);

    MdcGui_Gender = TextDrawCreate(329.000000, 252.000000, "~b~~h~~h~~h~Gender:");
    TextDrawAlignment(MdcGui_Gender, 3);
    TextDrawBackgroundColor(MdcGui_Gender, 255);
    TextDrawFont(MdcGui_Gender, 2);
    TextDrawLetterSize(MdcGui_Gender, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Gender, -524057345);
    TextDrawSetOutline(MdcGui_Gender, 0);
    TextDrawSetProportional(MdcGui_Gender, 1);
    TextDrawSetShadow(MdcGui_Gender, 1);
    TextDrawSetSelectable(MdcGui_Gender, 0);

    MdcGui_Job = TextDrawCreate(329.000000, 264.000000, "~b~~h~~h~~h~Occupation:");
    TextDrawAlignment(MdcGui_Job, 3);
    TextDrawBackgroundColor(MdcGui_Job, 255);
    TextDrawFont(MdcGui_Job, 2);
    TextDrawLetterSize(MdcGui_Job, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Job, -524057345);
    TextDrawSetOutline(MdcGui_Job, 0);
    TextDrawSetProportional(MdcGui_Job, 1);
    TextDrawSetShadow(MdcGui_Job, 1);
    TextDrawSetSelectable(MdcGui_Job, 0);

    MdcGui_DriveLic = TextDrawCreate(329.000000, 276.000000, "~b~~h~~h~~h~Driver's License:");
    TextDrawAlignment(MdcGui_DriveLic, 3);
    TextDrawBackgroundColor(MdcGui_DriveLic, 255);
    TextDrawFont(MdcGui_DriveLic, 2);
    TextDrawLetterSize(MdcGui_DriveLic, 0.170000, 1.000000);
    TextDrawColor(MdcGui_DriveLic, -524057345);
    TextDrawSetOutline(MdcGui_DriveLic, 0);
    TextDrawSetProportional(MdcGui_DriveLic, 1);
    TextDrawSetShadow(MdcGui_DriveLic, 1);
    TextDrawSetSelectable(MdcGui_DriveLic, 0);

    MdcGui_GunLic = TextDrawCreate(329.000000, 288.000000, "~b~~h~~h~~h~Weapon License:");
    TextDrawAlignment(MdcGui_GunLic, 3);
    TextDrawBackgroundColor(MdcGui_GunLic, 255);
    TextDrawFont(MdcGui_GunLic, 2);
    TextDrawLetterSize(MdcGui_GunLic, 0.170000, 1.000000);
    TextDrawColor(MdcGui_GunLic, -524057345);
    TextDrawSetOutline(MdcGui_GunLic, 0);
    TextDrawSetProportional(MdcGui_GunLic, 1);
    TextDrawSetShadow(MdcGui_GunLic, 1);
    TextDrawSetSelectable(MdcGui_GunLic, 0);

    MdcGui_PhoneNumber = TextDrawCreate(329.000000, 300.000000, "~b~~h~~h~~h~Phone Number:");
    TextDrawAlignment(MdcGui_PhoneNumber, 3);
    TextDrawBackgroundColor(MdcGui_PhoneNumber, 255);
    TextDrawFont(MdcGui_PhoneNumber, 2);
    TextDrawLetterSize(MdcGui_PhoneNumber, 0.170000, 1.000000);
    TextDrawColor(MdcGui_PhoneNumber, -524057345);
    TextDrawSetOutline(MdcGui_PhoneNumber, 0);
    TextDrawSetProportional(MdcGui_PhoneNumber, 1);
    TextDrawSetShadow(MdcGui_PhoneNumber, 1);
    TextDrawSetSelectable(MdcGui_PhoneNumber, 0);

    MdcGui_Name = TextDrawCreate(329.000000, 228.000000, "~b~~h~~h~~h~Full Name:");
    TextDrawAlignment(MdcGui_Name, 3);
    TextDrawBackgroundColor(MdcGui_Name, 255);
    TextDrawFont(MdcGui_Name, 2);
    TextDrawLetterSize(MdcGui_Name, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Name, -524057345);
    TextDrawSetOutline(MdcGui_Name, 0);
    TextDrawSetProportional(MdcGui_Name, 1);
    TextDrawSetShadow(MdcGui_Name, 1);
    TextDrawSetSelectable(MdcGui_Name, 0);

    MdcGui_PropertiesArrow = TextDrawCreate(411.000000, 357.000000, "LD_BEAT:right");
    TextDrawBackgroundColor(MdcGui_PropertiesArrow, 255);
    TextDrawFont(MdcGui_PropertiesArrow, 4);
    TextDrawLetterSize(MdcGui_PropertiesArrow, 0.500000, 1.000000);
    TextDrawColor(MdcGui_PropertiesArrow, -1);
    TextDrawSetOutline(MdcGui_PropertiesArrow, 0);
    TextDrawSetProportional(MdcGui_PropertiesArrow, 1);
    TextDrawSetShadow(MdcGui_PropertiesArrow, 1);
    TextDrawUseBox(MdcGui_PropertiesArrow, 1);
    TextDrawBoxColor(MdcGui_PropertiesArrow, 255);
    TextDrawTextSize(MdcGui_PropertiesArrow, 10.000000, 14.000000);
    TextDrawSetSelectable(MdcGui_PropertiesArrow, 1);

    MdcGui_VehiclesArrow = TextDrawCreate(411.000000, 337.000000, "LD_BEAT:right");
    TextDrawBackgroundColor(MdcGui_VehiclesArrow, 255);
    TextDrawFont(MdcGui_VehiclesArrow, 4);
    TextDrawLetterSize(MdcGui_VehiclesArrow, 0.500000, 1.000000);
    TextDrawColor(MdcGui_VehiclesArrow, -1);
    TextDrawSetOutline(MdcGui_VehiclesArrow, 0);
    TextDrawSetProportional(MdcGui_VehiclesArrow, 1);
    TextDrawSetShadow(MdcGui_VehiclesArrow, 1);
    TextDrawUseBox(MdcGui_VehiclesArrow, 1);
    TextDrawBoxColor(MdcGui_VehiclesArrow, 255);
    TextDrawTextSize(MdcGui_VehiclesArrow, 10.000000, 14.000000);
    TextDrawSetSelectable(MdcGui_VehiclesArrow, 1);

    MdcGui_Vehicles = TextDrawCreate(372.000000, 338.000000, "~b~~h~~h~~h~Vehicles");
    TextDrawBackgroundColor(MdcGui_Vehicles, 255);
    TextDrawFont(MdcGui_Vehicles, 2);
    TextDrawLetterSize(MdcGui_Vehicles, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Vehicles, -524057345);
    TextDrawSetOutline(MdcGui_Vehicles, 0);
    TextDrawSetProportional(MdcGui_Vehicles, 1);
    TextDrawSetShadow(MdcGui_Vehicles, 1);
    TextDrawTextSize(MdcGui_Vehicles, 410.0, 20.0);
    TextDrawSetSelectable(MdcGui_Vehicles, 1);

    MdcGui_Properties = TextDrawCreate(363.000000, 358.000000, "~b~~h~~h~~h~Properties");
    TextDrawBackgroundColor(MdcGui_Properties, 255);
    TextDrawFont(MdcGui_Properties, 2);
    TextDrawLetterSize(MdcGui_Properties, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Properties, -524057345);
    TextDrawSetOutline(MdcGui_Properties, 0);
    TextDrawSetProportional(MdcGui_Properties, 1);
    TextDrawSetShadow(MdcGui_Properties, 1);
    TextDrawTextSize(MdcGui_Properties, 410.0, 20.0);
    TextDrawSetSelectable(MdcGui_Properties, 1);

    MdcGui_Age = TextDrawCreate(329.000000, 240.000000, "~b~~h~~h~~h~Age:");
    TextDrawAlignment(MdcGui_Age, 3);
    TextDrawBackgroundColor(MdcGui_Age, 255);
    TextDrawFont(MdcGui_Age, 2);
    TextDrawLetterSize(MdcGui_Age, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Age, -524057345);
    TextDrawSetOutline(MdcGui_Age, 0);
    TextDrawSetProportional(MdcGui_Age, 1);
    TextDrawSetShadow(MdcGui_Age, 1);
    TextDrawSetSelectable(MdcGui_Age, 0);

    MdcGui_CasesArrow = TextDrawCreate(219.000000, 357.000000, "LD_BEAT:left");
    TextDrawBackgroundColor(MdcGui_CasesArrow, 255);
    TextDrawFont(MdcGui_CasesArrow, 4);
    TextDrawLetterSize(MdcGui_CasesArrow, 0.500000, 1.000000);
    TextDrawColor(MdcGui_CasesArrow, -1);
    TextDrawSetOutline(MdcGui_CasesArrow, 0);
    TextDrawSetProportional(MdcGui_CasesArrow, 1);
    TextDrawSetShadow(MdcGui_CasesArrow, 1);
    TextDrawUseBox(MdcGui_CasesArrow, 1);
    TextDrawBoxColor(MdcGui_CasesArrow, 255);
    TextDrawTextSize(MdcGui_CasesArrow, 10.000000, 14.000000);
    TextDrawSetSelectable(MdcGui_CasesArrow, 1);

    MdcGui_CriminalRecordArrow = TextDrawCreate(219.000000, 337.000000, "LD_BEAT:left");
    TextDrawBackgroundColor(MdcGui_CriminalRecordArrow, 255);
    TextDrawFont(MdcGui_CriminalRecordArrow, 4);
    TextDrawLetterSize(MdcGui_CriminalRecordArrow, 0.500000, 1.000000);
    TextDrawColor(MdcGui_CriminalRecordArrow, -1);
    TextDrawSetOutline(MdcGui_CriminalRecordArrow, 0);
    TextDrawSetProportional(MdcGui_CriminalRecordArrow, 1);
    TextDrawSetShadow(MdcGui_CriminalRecordArrow, 1);
    TextDrawUseBox(MdcGui_CriminalRecordArrow, 1);
    TextDrawBoxColor(MdcGui_CriminalRecordArrow, 255);
    TextDrawTextSize(MdcGui_CriminalRecordArrow, 10.000000, 14.000000);
    TextDrawSetSelectable(MdcGui_CriminalRecordArrow, 1);

    MdcGui_CriminalRecord = TextDrawCreate(233.000000, 338.000000, "~b~~h~~h~~h~Criminal Record");
    TextDrawBackgroundColor(MdcGui_CriminalRecord, 255);
    TextDrawFont(MdcGui_CriminalRecord, 2);
    TextDrawLetterSize(MdcGui_CriminalRecord, 0.170000, 1.000000);
    TextDrawColor(MdcGui_CriminalRecord, -524057345);
    TextDrawSetOutline(MdcGui_CriminalRecord, 0);
    TextDrawSetProportional(MdcGui_CriminalRecord, 1);
    TextDrawSetShadow(MdcGui_CriminalRecord, 1);
    TextDrawTextSize(MdcGui_CriminalRecord, 294.0, 20.0);
    TextDrawSetSelectable(MdcGui_CriminalRecord, 1);

    MdcGui_Cases = TextDrawCreate(233.000000, 358.000000, "~b~~h~~h~~h~Cases");
    TextDrawBackgroundColor(MdcGui_Cases, 255);
    TextDrawFont(MdcGui_Cases, 2);
    TextDrawLetterSize(MdcGui_Cases, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Cases, -524057345);
    TextDrawSetOutline(MdcGui_Cases, 0);
    TextDrawSetProportional(MdcGui_Cases, 1);
    TextDrawSetShadow(MdcGui_Cases, 1);
    TextDrawTextSize(MdcGui_Cases, 260.0, 20.0);
    TextDrawSetSelectable(MdcGui_Cases, 1);

    MdcGui_Browse = TextDrawCreate(207.000000, 321.000000, "~b~Browse");
    TextDrawBackgroundColor(MdcGui_Browse, 255);
    TextDrawFont(MdcGui_Browse, 2);
    TextDrawLetterSize(MdcGui_Browse, 0.170000, 1.000000);
    TextDrawColor(MdcGui_Browse, -1384438529);
    TextDrawSetOutline(MdcGui_Browse, 0);
    TextDrawSetProportional(MdcGui_Browse, 1);
    TextDrawSetShadow(MdcGui_Browse, 1);
    TextDrawSetSelectable(MdcGui_Browse, 0);

    MdcGui_cr_TypeTitle = TextDrawCreate(220.000000, 234.000000, "~b~~h~~h~~h~Type");
    TextDrawBackgroundColor(MdcGui_cr_TypeTitle, 255);
    TextDrawFont(MdcGui_cr_TypeTitle, 2);
    TextDrawLetterSize(MdcGui_cr_TypeTitle, 0.170000, 1.000000);
    TextDrawColor(MdcGui_cr_TypeTitle, -524057345);
    TextDrawSetOutline(MdcGui_cr_TypeTitle, 0);
    TextDrawSetProportional(MdcGui_cr_TypeTitle, 1);
    TextDrawSetShadow(MdcGui_cr_TypeTitle, 1);
    TextDrawSetSelectable(MdcGui_cr_TypeTitle, 0);

    MdcGui_cr_DescriptionTitle = TextDrawCreate(257.000000, 234.000000, "~b~~h~~h~~h~Description");
    TextDrawBackgroundColor(MdcGui_cr_DescriptionTitle, 255);
    TextDrawFont(MdcGui_cr_DescriptionTitle, 2);
    TextDrawLetterSize(MdcGui_cr_DescriptionTitle, 0.170000, 1.000000);
    TextDrawColor(MdcGui_cr_DescriptionTitle, -524057345);
    TextDrawSetOutline(MdcGui_cr_DescriptionTitle, 0);
    TextDrawSetProportional(MdcGui_cr_DescriptionTitle, 1);
    TextDrawSetShadow(MdcGui_cr_DescriptionTitle, 1);
    TextDrawSetSelectable(MdcGui_cr_DescriptionTitle, 0);

    MdcGui_cr_DateTitle = TextDrawCreate(375.000000, 234.000000, "~b~~h~~h~~h~Date");
    TextDrawAlignment(MdcGui_cr_DateTitle, 2);
    TextDrawBackgroundColor(MdcGui_cr_DateTitle, 255);
    TextDrawFont(MdcGui_cr_DateTitle, 2);
    TextDrawLetterSize(MdcGui_cr_DateTitle, 0.170000, 1.000000);
    TextDrawColor(MdcGui_cr_DateTitle, -524057345);
    TextDrawSetOutline(MdcGui_cr_DateTitle, 0);
    TextDrawSetProportional(MdcGui_cr_DateTitle, 1);
    TextDrawSetShadow(MdcGui_cr_DateTitle, 1);
    TextDrawSetSelectable(MdcGui_cr_DateTitle, 0);

    for (new i = 0; i < sizeof(MdcGui_cr_Info); i++)
    {
        MdcGui_cr_Info[i] = TextDrawCreate(412.000000, 249.000000 + i * 15, "LD_CHAT:badchat");
        TextDrawBackgroundColor(MdcGui_cr_Info[i], 255);
        TextDrawFont(MdcGui_cr_Info[i], 4);
        TextDrawLetterSize(MdcGui_cr_Info[i], 0.500000, 1.000000);
        TextDrawColor(MdcGui_cr_Info[i], -1);
        TextDrawSetOutline(MdcGui_cr_Info[i], 0);
        TextDrawSetProportional(MdcGui_cr_Info[i], 1);
        TextDrawSetShadow(MdcGui_cr_Info[i], 1);
        TextDrawUseBox(MdcGui_cr_Info[i], 1);
        TextDrawBoxColor(MdcGui_cr_Info[i], 255);
        TextDrawTextSize(MdcGui_cr_Info[i], 8.000000, 9.000000);
        TextDrawSetSelectable(MdcGui_cr_Info[i], 1);
    }

    MdcGui_cr_ArrowDown = TextDrawCreate(425.000000, 351.000000, "LD_BEAT:down");
    TextDrawBackgroundColor(MdcGui_cr_ArrowDown, 255);
    TextDrawFont(MdcGui_cr_ArrowDown, 4);
    TextDrawLetterSize(MdcGui_cr_ArrowDown, 0.500000, 1.000000);
    TextDrawColor(MdcGui_cr_ArrowDown, -1);
    TextDrawSetOutline(MdcGui_cr_ArrowDown, 0);
    TextDrawSetProportional(MdcGui_cr_ArrowDown, 1);
    TextDrawSetShadow(MdcGui_cr_ArrowDown, 1);
    TextDrawUseBox(MdcGui_cr_ArrowDown, 1);
    TextDrawBoxColor(MdcGui_cr_ArrowDown, 255);
    TextDrawTextSize(MdcGui_cr_ArrowDown, 11.000000, 12.000000);
    TextDrawSetSelectable(MdcGui_cr_ArrowDown, 1);

    MdcGui_cr_ArrowUp = TextDrawCreate(425.000000, 335.000000, "LD_BEAT:up");
    TextDrawBackgroundColor(MdcGui_cr_ArrowUp, 255);
    TextDrawFont(MdcGui_cr_ArrowUp, 4);
    TextDrawLetterSize(MdcGui_cr_ArrowUp, 0.500000, 1.000000);
    TextDrawColor(MdcGui_cr_ArrowUp, -1);
    TextDrawSetOutline(MdcGui_cr_ArrowUp, 0);
    TextDrawSetProportional(MdcGui_cr_ArrowUp, 1);
    TextDrawSetShadow(MdcGui_cr_ArrowUp, 1);
    TextDrawUseBox(MdcGui_cr_ArrowUp, 1);
    TextDrawBoxColor(MdcGui_cr_ArrowUp, 255);
    TextDrawTextSize(MdcGui_cr_ArrowUp, 11.000000, 12.000000);
    TextDrawSetSelectable(MdcGui_cr_ArrowUp, 1);

    MdcGui_cr_Title = TextDrawCreate(207.000000, 220.000000, "~b~Criminal Record");
    TextDrawBackgroundColor(MdcGui_cr_Title, 255);
    TextDrawFont(MdcGui_cr_Title, 2);
    TextDrawLetterSize(MdcGui_cr_Title, 0.170000, 1.000000);
    TextDrawColor(MdcGui_cr_Title, -1384438529);
    TextDrawSetOutline(MdcGui_cr_Title, 0);
    TextDrawSetProportional(MdcGui_cr_Title, 1);
    TextDrawSetShadow(MdcGui_cr_Title, 1);
    TextDrawSetSelectable(MdcGui_cr_Title, 0);
    return 1;
}

mdc_LoadPlayerTextdraws(playerid)
{
    MdcGui_Skin = CreatePlayerTextDraw(playerid, 264.000000, 231.000000, "New Textdraw");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_Skin, 0);
    PlayerTextDrawFont(playerid, MdcGui_Skin, 5);
    PlayerTextDrawLetterSize(playerid, MdcGui_Skin, 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_Skin, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_Skin, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_Skin, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_Skin, 1);
    PlayerTextDrawUseBox(playerid, MdcGui_Skin, 1);
    PlayerTextDrawBoxColor(playerid, MdcGui_Skin, 0);
    PlayerTextDrawTextSize(playerid, MdcGui_Skin, -70.000000, 80.000000);
    PlayerTextDrawSetPreviewModel(playerid, MdcGui_Skin, 107);
    PlayerTextDrawSetPreviewRot(playerid, MdcGui_Skin, -16.000000, 0.000000, -30.000000, 1.000000);
    PlayerTextDrawSetSelectable(playerid, MdcGui_Skin, 0);

    MdcGui_NameValue = CreatePlayerTextDraw(playerid, 338.000000, 228.000000, "Firstname Lastname");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_NameValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_NameValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_NameValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_NameValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_NameValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_NameValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_NameValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_NameValue, 0);

    MdcGui_AgeValue = CreatePlayerTextDraw(playerid, 338.000000, 240.000000, "21");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_AgeValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_AgeValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_AgeValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_AgeValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_AgeValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_AgeValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_AgeValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_AgeValue, 0);

    MdcGui_GenderValue = CreatePlayerTextDraw(playerid, 338.000000, 252.000000, "Male");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_GenderValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_GenderValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_GenderValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_GenderValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_GenderValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_GenderValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_GenderValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_GenderValue, 0);

    MdcGui_JobValue = CreatePlayerTextDraw(playerid, 338.000000, 264.000000, "Unemployed");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_JobValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_JobValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_JobValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_JobValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_JobValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_JobValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_JobValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_JobValue, 0);

    MdcGui_DriveLicValue = CreatePlayerTextDraw(playerid, 338.000000, 276.000000, "Passed");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_DriveLicValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_DriveLicValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_DriveLicValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_DriveLicValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_DriveLicValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_DriveLicValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_DriveLicValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_DriveLicValue, 0);

    MdcGui_GunLicValue = CreatePlayerTextDraw(playerid, 338.000000, 288.000000, "Not Passed");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_GunLicValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_GunLicValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_GunLicValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_GunLicValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_GunLicValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_GunLicValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_GunLicValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_GunLicValue, 0);

    MdcGui_PhoneNumberValue = CreatePlayerTextDraw(playerid, 338.000000, 300.000000, "4701958");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_PhoneNumberValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_PhoneNumberValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_PhoneNumberValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_PhoneNumberValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_PhoneNumberValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_PhoneNumberValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_PhoneNumberValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_PhoneNumberValue, 0);

    for (new i = 0; i < sizeof(MdcGui_cr_Date); i++)
    {
        MdcGui_cr_Date[i] = CreatePlayerTextDraw(playerid, 366.000000, 249.000000 + i * 15, "21.02.2014");
        PlayerTextDrawBackgroundColor(playerid, MdcGui_cr_Date[i], 255);
        PlayerTextDrawFont(playerid, MdcGui_cr_Date[i], 2);
        PlayerTextDrawLetterSize(playerid, MdcGui_cr_Date[i], 0.170000, 1.000000);
        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], -1);
        PlayerTextDrawSetOutline(playerid, MdcGui_cr_Date[i], 0);
        PlayerTextDrawSetProportional(playerid, MdcGui_cr_Date[i], 1);
        PlayerTextDrawSetShadow(playerid, MdcGui_cr_Date[i], 1);
        PlayerTextDrawSetSelectable(playerid, MdcGui_cr_Date[i], 0);

        MdcGui_cr_Description[i] = CreatePlayerTextDraw(playerid, 257.000000, 249.000000 + i * 15, "Possession of a firearm w...");
        PlayerTextDrawBackgroundColor(playerid, MdcGui_cr_Description[i], 255);
        PlayerTextDrawFont(playerid, MdcGui_cr_Description[i], 2);
        PlayerTextDrawLetterSize(playerid, MdcGui_cr_Description[i], 0.170000, 1.000000);
        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], -1);
        PlayerTextDrawSetOutline(playerid, MdcGui_cr_Description[i], 0);
        PlayerTextDrawSetProportional(playerid, MdcGui_cr_Description[i], 1);
        PlayerTextDrawSetShadow(playerid, MdcGui_cr_Description[i], 1);
        PlayerTextDrawSetSelectable(playerid, MdcGui_cr_Description[i], 0);

        MdcGui_cr_Type[i] = CreatePlayerTextDraw(playerid, 220.000000, 249.000000 + i * 15, "Ticket");
        PlayerTextDrawBackgroundColor(playerid, MdcGui_cr_Type[i], 255);
        PlayerTextDrawFont(playerid, MdcGui_cr_Type[i], 2);
        PlayerTextDrawLetterSize(playerid, MdcGui_cr_Type[i], 0.170000, 1.000000);
        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], -1);
        PlayerTextDrawSetOutline(playerid, MdcGui_cr_Type[i], 0);
        PlayerTextDrawSetProportional(playerid, MdcGui_cr_Type[i], 1);
        PlayerTextDrawSetShadow(playerid, MdcGui_cr_Type[i], 1);
        PlayerTextDrawSetSelectable(playerid, MdcGui_cr_Type[i], 0);
    }

    MdcGui_veh_ModelValue = CreatePlayerTextDraw(playerid, 338.000000, 228.000000, "Landstalker");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_veh_ModelValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_veh_ModelValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_veh_ModelValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_veh_ModelValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_veh_ModelValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_veh_ModelValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_veh_ModelValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_veh_ModelValue, 0);

    MdcGui_veh_VehicleModel = CreatePlayerTextDraw(playerid, 191.000000, 200.000000, "New Textdraw");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_veh_VehicleModel, 0);
    PlayerTextDrawFont(playerid, MdcGui_veh_VehicleModel, 5);
    PlayerTextDrawLetterSize(playerid, MdcGui_veh_VehicleModel, 0.500000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_veh_VehicleModel, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_veh_VehicleModel, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_veh_VehicleModel, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_veh_VehicleModel, 1);
    PlayerTextDrawUseBox(playerid, MdcGui_veh_VehicleModel, 1);
    PlayerTextDrawBoxColor(playerid, MdcGui_veh_VehicleModel, 0);
    PlayerTextDrawTextSize(playerid, MdcGui_veh_VehicleModel, 68.000000, 94.000000);
    PlayerTextDrawSetPreviewModel(playerid, MdcGui_veh_VehicleModel, 400);
    PlayerTextDrawSetPreviewRot(playerid, MdcGui_veh_VehicleModel, -16.000000, 0.000000, 35.000000, 1.000000);
    PlayerTextDrawSetSelectable(playerid, MdcGui_veh_VehicleModel, 0);

    MdcGui_veh_OwnerValue = CreatePlayerTextDraw(playerid, 338.000000, 240.000000, "Test Name");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_veh_OwnerValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_veh_OwnerValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_veh_OwnerValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_veh_OwnerValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_veh_OwnerValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_veh_OwnerValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_veh_OwnerValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_veh_OwnerValue, 0);

    MdcGui_veh_PlateValue = CreatePlayerTextDraw(playerid, 338.000000, 252.000000, "P-205-LS");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_veh_PlateValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_veh_PlateValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_veh_PlateValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_veh_PlateValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_veh_PlateValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_veh_PlateValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_veh_PlateValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_veh_PlateValue, 0);

    MdcGui_veh_InsuranceValue = CreatePlayerTextDraw(playerid, 338.000000, 264.000000, "Yes");
    PlayerTextDrawBackgroundColor(playerid, MdcGui_veh_InsuranceValue, 255);
    PlayerTextDrawFont(playerid, MdcGui_veh_InsuranceValue, 2);
    PlayerTextDrawLetterSize(playerid, MdcGui_veh_InsuranceValue, 0.170000, 1.000000);
    PlayerTextDrawColor(playerid, MdcGui_veh_InsuranceValue, -1);
    PlayerTextDrawSetOutline(playerid, MdcGui_veh_InsuranceValue, 0);
    PlayerTextDrawSetProportional(playerid, MdcGui_veh_InsuranceValue, 1);
    PlayerTextDrawSetShadow(playerid, MdcGui_veh_InsuranceValue, 1);
    PlayerTextDrawSetSelectable(playerid, MdcGui_veh_InsuranceValue, 0);

}

mdc_ShowPlayerStartScreen(playerid)
{
    TextDrawShowForPlayer(playerid, MdcGui_Box);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderBox);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderText);
    TextDrawShowForPlayer(playerid, MdcGui_Exit);
    for (new i = 0; i < sizeof(MdcGui_Section); i++)
    {
        TextDrawShowForPlayer(playerid, MdcGui_Section[i]);
        TextDrawShowForPlayer(playerid, MdcGui_SectionText[i]);
    }

    TextDrawShowForPlayer(playerid, MdcGui_SectionHeaderText);
    SelectTextDraw(playerid, -1);
}

mdc_Hide(playerid, bool:close = false)
{
    TextDrawHideForPlayer(playerid, MdcGui_CitizenBox);
    TextDrawHideForPlayer(playerid, MdcGui_Box);
    TextDrawHideForPlayer(playerid, MdcGui_HeaderBox);
    TextDrawHideForPlayer(playerid, MdcGui_DataBox);
    TextDrawHideForPlayer(playerid, MdcGui_OptionsBox);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Box);
    TextDrawHideForPlayer(playerid, MdcGui_veh_InnerBox);
    TextDrawHideForPlayer(playerid, MdcGui_veh_BoxNoEnt);
    TextDrawHideForPlayer(playerid, MdcGui_veh_InnerBoxNoEnt);
    for (new i = 0; i < sizeof(MdcGui_cr_Box); i++)
    {
        TextDrawHideForPlayer(playerid, MdcGui_cr_Box[i]);
    }

    for (new i = 0; i < sizeof(MdcGui_cr_InnerBox); i++)
    {
        TextDrawHideForPlayer(playerid, MdcGui_cr_InnerBox[i]);
    }

    TextDrawHideForPlayer(playerid, MdcGui_HeaderText);
    TextDrawHideForPlayer(playerid, MdcGui_Exit);
    for (new i = 0; i < sizeof(MdcGui_Section); i++)
    {
        TextDrawHideForPlayer(playerid, MdcGui_Section[i]);
        TextDrawHideForPlayer(playerid, MdcGui_SectionText[i]);
    }

    TextDrawHideForPlayer(playerid, MdcGui_SectionHeaderText);
    TextDrawHideForPlayer(playerid, MdcGui_Gender);
    TextDrawHideForPlayer(playerid, MdcGui_Job);
    TextDrawHideForPlayer(playerid, MdcGui_DriveLic);
    TextDrawHideForPlayer(playerid, MdcGui_GunLic);
    TextDrawHideForPlayer(playerid, MdcGui_PhoneNumber);
    TextDrawHideForPlayer(playerid, MdcGui_Name);
    TextDrawHideForPlayer(playerid, MdcGui_PropertiesArrow);
    TextDrawHideForPlayer(playerid, MdcGui_VehiclesArrow);
    TextDrawHideForPlayer(playerid, MdcGui_Vehicles);
    TextDrawHideForPlayer(playerid, MdcGui_Properties);
    TextDrawHideForPlayer(playerid, MdcGui_Age);
    TextDrawHideForPlayer(playerid, MdcGui_CriminalRecordArrow);
    TextDrawHideForPlayer(playerid, MdcGui_CasesArrow);
    TextDrawHideForPlayer(playerid, MdcGui_CriminalRecord);
    TextDrawHideForPlayer(playerid, MdcGui_Cases);
    TextDrawHideForPlayer(playerid, MdcGui_Browse);
    PlayerTextDrawHide(playerid, MdcGui_Skin);
    PlayerTextDrawHide(playerid, MdcGui_NameValue);
    PlayerTextDrawHide(playerid, MdcGui_AgeValue);
    PlayerTextDrawHide(playerid, MdcGui_GenderValue);
    PlayerTextDrawHide(playerid, MdcGui_JobValue);
    PlayerTextDrawHide(playerid, MdcGui_DriveLicValue);
    PlayerTextDrawHide(playerid, MdcGui_GunLicValue);
    PlayerTextDrawHide(playerid, MdcGui_PhoneNumberValue);
    TextDrawHideForPlayer(playerid, MdcGui_cr_Title);
    TextDrawHideForPlayer(playerid, MdcGui_cr_ArrowUp);
    TextDrawHideForPlayer(playerid, MdcGui_cr_ArrowDown);
    TextDrawHideForPlayer(playerid, MdcGui_cr_TypeTitle);
    TextDrawHideForPlayer(playerid, MdcGui_cr_DescriptionTitle);
    TextDrawHideForPlayer(playerid, MdcGui_cr_DateTitle);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Model);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Owner);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Plate);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Insurance);
    TextDrawHideForPlayer(playerid, MdcGui_veh_ArrowRight);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Next);
    TextDrawHideForPlayer(playerid, MdcGui_veh_Label);
    PlayerTextDrawHide(playerid, MdcGui_veh_ModelValue);
    PlayerTextDrawHide(playerid, MdcGui_veh_VehicleModel);
    PlayerTextDrawHide(playerid, MdcGui_veh_OwnerValue);
    PlayerTextDrawHide(playerid, MdcGui_veh_PlateValue);
    PlayerTextDrawHide(playerid, MdcGui_veh_InsuranceValue);
    TextDrawHideForPlayer(playerid, MdcGui_veh_TextNoEnt);
    for (new i = 0; i < sizeof(MdcGui_cr_Info); i++)
    {
        TextDrawHideForPlayer(playerid, MdcGui_cr_Info[i]);
    }

    for (new i = 0; i < sizeof(MdcGui_cr_Info); i++)
    {
        PlayerTextDrawHide(playerid, MdcGui_cr_Type[i]);
        PlayerTextDrawHide(playerid, MdcGui_cr_Description[i]);
        PlayerTextDrawHide(playerid, MdcGui_cr_Date[i]);
    }

    if (close != false)
    {
        DeletePVar(playerid, "mdc_Citizen");
        DeletePVar(playerid, "mdc_VehicleIndex");
        DeletePVar(playerid, "mdc_Shown");
        CancelSelectTextDraw(playerid);
    }
}

mdc_SearchCitizen(playerid, name[])
{
    new user;
    for (new i = 0; i < strlen(name); i++)
    {
        if (name[i] == ' ')
        {
            name[i] = '_';
        }
    }

    user = GetPlayerID(name);
    if (IsPlayerConnected(user))
    {
        SetPVarString(playerid, "mdc_Citizen", name);
        mdc_ShowCitizen(playerid,
            GetPlayerNameEx(user),
            GetPlayerSkin(user),
            PlayerData[user][pAge],
          _:PlayerData[user][pGender],
            PlayerHasLicense(playerid, PlayerLicense_Car),
            PlayerHasLicense(playerid, PlayerLicense_Gun),
            PlayerData[user][pJob],
            PlayerData[user][pPhone]);
    }
    else
    {
        DBFormat("SELECT skin, age, gender, carlicense, gunlicense, job, phone FROM users WHERE username = '%e';", name);
        DBExecute("MdcSearchCitizenResult", "ds", playerid, name);
    }
}

mdc_ShowCitizen(playerid, name[], skin, age, sex, driveLic, weaponLic, jobid, phoneNumber)
{
    new value[20];
    mdc_Hide(playerid, false);

    // Skin
    PlayerTextDrawSetPreviewModel(playerid, MdcGui_Skin, skin);
    PlayerTextDrawShow(playerid, MdcGui_Skin);

    // Name
    PlayerTextDrawSetString(playerid, MdcGui_NameValue, name);
    PlayerTextDrawShow(playerid, MdcGui_NameValue);

    // Age
    format(value, sizeof(value), "%i", age);
    PlayerTextDrawSetString(playerid, MdcGui_AgeValue, value);
    PlayerTextDrawShow(playerid, MdcGui_AgeValue);

    // Gender
    PlayerTextDrawSetString(playerid, MdcGui_GenderValue, GenderToString(sex));
    PlayerTextDrawShow(playerid, MdcGui_GenderValue);

    // Job
    PlayerTextDrawSetString(playerid, MdcGui_JobValue, GetJobName(jobid));
    PlayerTextDrawShow(playerid, MdcGui_JobValue);

    // Driver's License
    PlayerTextDrawSetString(playerid, MdcGui_DriveLicValue, DriveLicenseToString(driveLic));
    PlayerTextDrawShow(playerid, MdcGui_DriveLicValue);

    // Weapon License
    PlayerTextDrawSetString(playerid, MdcGui_GunLicValue, WeaponLicenseToString(weaponLic));
    PlayerTextDrawShow(playerid, MdcGui_GunLicValue);

    // Phone Number
    format(value, sizeof(value), "%i", phoneNumber);
    PlayerTextDrawSetString(playerid, MdcGui_PhoneNumberValue, value);
    PlayerTextDrawShow(playerid, MdcGui_PhoneNumberValue);

    // Other
    TextDrawShowForPlayer(playerid, MdcGui_CitizenBox);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderBox);
    TextDrawShowForPlayer(playerid, MdcGui_DataBox);
    TextDrawShowForPlayer(playerid, MdcGui_OptionsBox);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderText);
    TextDrawShowForPlayer(playerid, MdcGui_Exit);
    TextDrawShowForPlayer(playerid, MdcGui_Gender);
    TextDrawShowForPlayer(playerid, MdcGui_Job);
    TextDrawShowForPlayer(playerid, MdcGui_DriveLic);
    TextDrawShowForPlayer(playerid, MdcGui_GunLic);
    TextDrawShowForPlayer(playerid, MdcGui_PhoneNumber);
    TextDrawShowForPlayer(playerid, MdcGui_Name);
    TextDrawShowForPlayer(playerid, MdcGui_PropertiesArrow);
    TextDrawShowForPlayer(playerid, MdcGui_VehiclesArrow);
    TextDrawShowForPlayer(playerid, MdcGui_Vehicles);
    TextDrawShowForPlayer(playerid, MdcGui_Properties);
    TextDrawShowForPlayer(playerid, MdcGui_Age);
    TextDrawShowForPlayer(playerid, MdcGui_CriminalRecordArrow);
    TextDrawShowForPlayer(playerid, MdcGui_CasesArrow);
    TextDrawShowForPlayer(playerid, MdcGui_CriminalRecord);
    TextDrawShowForPlayer(playerid, MdcGui_Cases);
    TextDrawShowForPlayer(playerid, MdcGui_Browse);
    SelectTextDraw(playerid, -1);
}

mdc_ShowCriminalRecord(playerid, name[])
{
    DBFormat("SELECT officer, time, date, amount, reason, paid FROM "#TABLE_PDTICKET" WHERE player = '%e';", name);
    DBExecute("MdcFetchTickets", "ds", playerid, name);
}

mdc_ShowCriminalRecordDetails(playerid, idx)
{
    new dialogMsg[600];
    if (CriminalRecordData[playerid][idx][CR_Type] == RECORD_TICKET)
    {
        if (CriminalRecordData[playerid][idx][CR_Paid] == 0)
        {
            format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Ticket Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\
                                                  \n{ffffff}Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Price:\t\t{a9c4e4}$%i\n{ffffff}Offence:\t{a9c4e4}%s\n\n\
                                                  {ffffff}Information:\t{a9c4e4}The offender has {3D62A8}NOT {a9c4e4}yet paid the ticket.",
                                                  GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Offender]), GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Officer]),
                                                  CriminalRecordData[playerid][idx][CR_Date], CriminalRecordData[playerid][idx][CR_Time],
                                                  CriminalRecordData[playerid][idx][CR_Price], CriminalRecordData[playerid][idx][CR_Description]);
        }
        else
        {
            format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Ticket Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\n\
                                                  {ffffff}Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Price:\t\t{a9c4e4}$%i\n{ffffff}Offence:\t{a9c4e4}%s\n\n{ffffff}\
                                                  Information:\t{a9c4e4}The offender has paid the ticket.", GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Offender]),
                                                  GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Officer]), CriminalRecordData[playerid][idx][CR_Date],
                                                  CriminalRecordData[playerid][idx][CR_Time], CriminalRecordData[playerid][idx][CR_Price],
                                                  CriminalRecordData[playerid][idx][CR_Description]);
        }
    }
    else
    {
        if (CriminalRecordData[playerid][idx][CR_Served] == 0)
        {
            format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Charge Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\n\
                                                  {ffffff}Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Felony:\t\t{a9c4e4}%s\n\n{ffffff}Information:\t{a9c4e4}The offender \
                                                  is presently {3D62A8}WANTED {a9c4e4}due to this charge.", GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Offender]),
                                                  GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Officer]), CriminalRecordData[playerid][idx][CR_Date],
                                                  CriminalRecordData[playerid][idx][CR_Time], CriminalRecordData[playerid][idx][CR_Description]);
        }
        else
        {
            format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Charge Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\n{ffffff}\
                                                  Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Felony:\t\t{a9c4e4}%s\n\n{ffffff}Information:\t{a9c4e4}The offender has \
                                                  already served according time in prison.", GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Offender]),
                                                  GetNameWithSpace(CriminalRecordData[playerid][idx][CR_Officer]), CriminalRecordData[playerid][idx][CR_Date],
                                                  CriminalRecordData[playerid][idx][CR_Time], CriminalRecordData[playerid][idx][CR_Description]);
        }
    }

    Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{3D62A8}Detailed Record Information", dialogMsg, "Close", "");
}

stock GetPlayerCrimesCount(playerid)
{
    new crimes = 0;
    foreach(new i: RecordIterator[playerid])
    {
        if (RecordIterator[playerid][i])
        {
            crimes ++;
        }
    }
    return crimes;
}

mdc_ResetCriminalRecordData(playerid)
{
    for (new i = 0; i < MAX_CRIMINAL_RECORDS; i++)
    {
        for (new j = 0; j < sizeof(CriminalRecordData[][]); j++)
        {
            CriminalRecordData[playerid][i][CriminalRecordEnum:j] = 0;
        }
    }

    Iter_Clear(RecordIterator[playerid]);
}

mdc_ShowVehicles(playerid, name[])
{
    new query[140];
    format(query, sizeof(query), "SELECT `modelid`, `color1`, `color2`, `plate` FROM `vehicles` WHERE `owner` = '%e';", name);
    DBQueryWithCallback(query, "MdcFetchVehicle", "ds", playerid, name);
}

mdc_ShowVehicle(playerid, owner[], model, color1, color2, plate[], bool:nextBtn = false)
{
    mdc_Hide(playerid, false);

    // Model
    PlayerTextDrawSetString(playerid, MdcGui_veh_ModelValue, GetVehicleNameByModel(model));
    PlayerTextDrawShow(playerid, MdcGui_veh_ModelValue);

    // Model Preview
    PlayerTextDrawSetPreviewModel(playerid, MdcGui_veh_VehicleModel, model);
    PlayerTextDrawSetPreviewVehCol(playerid, MdcGui_veh_VehicleModel, color1, color2);
    PlayerTextDrawShow(playerid, MdcGui_veh_VehicleModel);

    // Owner
    PlayerTextDrawSetString(playerid, MdcGui_veh_OwnerValue, owner);
    PlayerTextDrawShow(playerid, MdcGui_veh_OwnerValue);

    // License Plate Number
    PlayerTextDrawSetString(playerid, MdcGui_veh_PlateValue, plate);
    PlayerTextDrawShow(playerid, MdcGui_veh_PlateValue);



    PlayerTextDrawShow(playerid, MdcGui_veh_InsuranceValue);
    TextDrawShowForPlayer(playerid, MdcGui_veh_Box);
    TextDrawShowForPlayer(playerid, MdcGui_veh_InnerBox);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderBox);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderText);
    TextDrawShowForPlayer(playerid, MdcGui_Exit);
    TextDrawShowForPlayer(playerid, MdcGui_veh_Model);
    TextDrawShowForPlayer(playerid, MdcGui_veh_Owner);
    TextDrawShowForPlayer(playerid, MdcGui_veh_Plate);
    TextDrawShowForPlayer(playerid, MdcGui_veh_Insurance);
    TextDrawShowForPlayer(playerid, MdcGui_veh_Label);
    if (nextBtn != false)
    {
        TextDrawShowForPlayer(playerid, MdcGui_veh_ArrowRight);
        TextDrawShowForPlayer(playerid, MdcGui_veh_Next);
    }

    SelectTextDraw(playerid, -1);
}

IsPlayerNearMDC(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        return 0;
    }

    if (VehicleInfo[vehicleid][vFaction] == PlayerData[playerid][pFaction])
    {
        return 1;
    }
    else
    {
        for (new i = 0; i < sizeof(mdc_coordinates); i++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 3.0, mdc_coordinates[i][0], mdc_coordinates[i][1], mdc_coordinates[i][2]))
            {
                return 1;
            }
        }
    }
    return 0;
}

DB:MdcSearchCitizenResult(playerid, name[])
{
    if (GetDBNumRows() > 0)
    {
        //TODO: fix car/gun license every where
        SetPVarString(playerid, "mdc_Citizen", name);
        mdc_ShowCitizen(playerid, GetNameWithSpace(name), GetDBIntField(0, "skin") , GetDBIntField(0, "age"), GetDBIntField(0, "gender"),
                        GetDBIntField(0, "carlicense"), GetDBIntField(0, "gunlicense"), GetDBIntField(0, "job"),
                        GetDBIntField(0, "phone"));
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "No citizen could be found under the mentioned name.");
        Dialog_Show(playerid, SearchCitizem, DIALOG_STYLE_INPUT, "{3D62A8}Search Citizen", "Please enter the citizen's full name below:", "Search", "Cancel");
    }
}

DB:MdcSearchPhoneNumber(playerid, phoneNum)
{
    if (GetDBNumRows() > 0)
    {
        new name[MAX_PLAYER_NAME];
        GetDBStringField(0, "username", name);
        SetPVarString(playerid, "mdc_Citizen", name);
        mdc_ShowCitizen(playerid, GetNameWithSpace(name), GetDBIntField(0, "skin") , GetDBIntField(0, "age"), GetDBIntField(0, "gender"),
                        GetDBIntField(0, "carlicense"), GetDBIntField(0, "gunlicense"), GetDBIntField(0, "job"),
                        phoneNum);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "No citizen could be associated with the mentioned phone number.");
        Dialog_Show(playerid, SearchPhoneNumber, DIALOG_STYLE_INPUT, "{3D62A8}Search Phone Number", "Please enter the phone number below:", "Search", "Cancel");
    }
}

DB:MdcSearchSerial(playerid)
{
    if (GetDBNumRows() > 0)
    {
        new name[MAX_PLAYER_NAME];
        GetDBStringField(0, "username", name);
        SetPVarString(playerid, "mdc_Citizen", name);
        mdc_ShowCitizen(playerid, GetNameWithSpace(name), GetDBIntField(0, "skin") , GetDBIntField(0, "age"), GetDBIntField(0, "gender"),
                        GetDBIntField(0, "carlicense"), GetDBIntField(0, "gunlicense"), GetDBIntField(0, "job"),
                        GetDBIntField(0, "phone"));
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "No citizen could be associated with the mentioned weapon serial number.");
        Dialog_Show(playerid, DIALOG_MDC_SEARCH_SERIAL, DIALOG_STYLE_INPUT, "{3D62A8}Search Weapon Serial", "Please enter the weapons's serial number below:", "Search", "Cancel");
    }
}

DB:MdcFetchTickets(playerid, name[])
{
    new idx;
    mdc_ResetCriminalRecordData(playerid);
    SetPVarInt(playerid, "CR_ScrollTop", 0);
    for (new i = 0; i < GetDBNumRows(); i++)
    {
        idx = Iter_Free(RecordIterator[playerid]);
        if (idx == -1)
        {
            break;
        }

        Iter_Add(RecordIterator[playerid], idx);
        format(CriminalRecordData[playerid][idx][CR_Offender], MAX_PLAYER_NAME, "%s", name);
        CriminalRecordData[playerid][idx][CR_Type] = RECORD_TICKET;
        GetDBStringField(i, "reason", CriminalRecordData[playerid][idx][CR_Description], 200);
        GetDBStringField(i, "time", CriminalRecordData[playerid][idx][CR_Time], 15);
        GetDBStringField(i, "date", CriminalRecordData[playerid][idx][CR_Date], 15);
        GetDBStringField(i, "officer", CriminalRecordData[playerid][idx][CR_Officer], MAX_PLAYER_NAME);
        CriminalRecordData[playerid][idx][CR_Paid] = GetDBIntField(i, "paid");
        CriminalRecordData[playerid][idx][CR_Price] = GetDBIntField(i, "amount");
    }

    new query[130];
    format(query, sizeof(query), "SELECT `officer`, `time`, `date`, `served`, `crime` FROM `criminals` WHERE `player` = '%e';", name);
    DBQueryWithCallback(query, "MdcFetchCharges", "ds", playerid, name);
}

DB:MdcFetchCharges(playerid, name[])
{
    new idx;
    for (new i = 0; i < GetDBNumRows(); i++)
    {
        idx = Iter_Free(RecordIterator[playerid]);
        if (idx == -1)
        {
            break;
        }

        Iter_Add(RecordIterator[playerid], idx);
        format(CriminalRecordData[playerid][idx][CR_Offender], MAX_PLAYER_NAME, "%s", name);
        CriminalRecordData[playerid][idx][CR_Type] = RECORD_CHARGE;
        GetDBStringField(i, "crime", CriminalRecordData[playerid][idx][CR_Description], 200);
        GetDBStringField(i, "time", CriminalRecordData[playerid][idx][CR_Time], 15);
        GetDBStringField(i, "date", CriminalRecordData[playerid][idx][CR_Date], 15);
        GetDBStringField(i, "officer", CriminalRecordData[playerid][idx][CR_Officer], MAX_PLAYER_NAME);
        CriminalRecordData[playerid][idx][CR_Served] = GetDBIntField(i, "served");
    }

    new count = Iter_Count(RecordIterator[playerid]);
    mdc_Hide(playerid, false);
    TextDrawShowForPlayer(playerid, MdcGui_HeaderBox);
    if (count >= 7)
    {
        TextDrawShowForPlayer(playerid, MdcGui_cr_Box[6]);
        TextDrawShowForPlayer(playerid, MdcGui_cr_InnerBox[6]);
    }
    else if (count > 1)
    {
        TextDrawShowForPlayer(playerid, MdcGui_cr_Box[count - 1]);
        TextDrawShowForPlayer(playerid, MdcGui_cr_InnerBox[count - 1]);
    }
    else
    {
        TextDrawShowForPlayer(playerid, MdcGui_cr_Box[0]);
        TextDrawShowForPlayer(playerid, MdcGui_cr_InnerBox[0]);
    }

    TextDrawShowForPlayer(playerid, MdcGui_HeaderText);
    TextDrawShowForPlayer(playerid, MdcGui_Exit);
    TextDrawShowForPlayer(playerid, MdcGui_cr_Title);
    TextDrawShowForPlayer(playerid, MdcGui_cr_TypeTitle);
    TextDrawShowForPlayer(playerid, MdcGui_cr_DescriptionTitle);
    TextDrawShowForPlayer(playerid, MdcGui_cr_DateTitle);
    if (count > 7)
    {
        TextDrawShowForPlayer(playerid, MdcGui_cr_ArrowUp);
        TextDrawShowForPlayer(playerid, MdcGui_cr_ArrowDown);
    }

    if (count <= 0)
    {
        PlayerTextDrawColor(playerid, MdcGui_cr_Type[0], COLOR_WHITE);
        PlayerTextDrawSetString(playerid, MdcGui_cr_Type[0], "No entries could be found.");
        PlayerTextDrawShow(playerid, MdcGui_cr_Type[0]);
    }
    else
    {
        for (new i = 0; i < sizeof(MdcGui_cr_Info); i++)
        {
            if (i >= count)
            {
                break;
            }

            if (CriminalRecordData[playerid][i][CR_Type] == RECORD_CHARGE)
            {
                PlayerTextDrawSetString(playerid, MdcGui_cr_Type[i], "Charge");
                if (CriminalRecordData[playerid][i][CR_Served] == 0)
                {
                    PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_RED);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_RED);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_RED);
                }
                else
                {
                    PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_WHITE);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_WHITE);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_WHITE);
                }
            }
            else
            {
                PlayerTextDrawSetString(playerid, MdcGui_cr_Type[i], "Ticket");
                if (CriminalRecordData[playerid][i][CR_Paid] == 0)
                {
                    PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_RED);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_RED);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_RED);
                }
                else
                {
                    PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_WHITE);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_WHITE);
                    PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_WHITE);
                }
            }

            PlayerTextDrawSetString(playerid, MdcGui_cr_Date[i], CriminalRecordData[playerid][i][CR_Date]);
            if (strlen(CriminalRecordData[playerid][i][CR_Description]) < 20)
            {
                PlayerTextDrawSetString(playerid, MdcGui_cr_Description[i], CriminalRecordData[playerid][i][CR_Description]);
            }
            else
            {
                new desc[25];
                strmid(desc, CriminalRecordData[playerid][i][CR_Description], 0, 20, 200);
                strins(desc, "...", strlen(desc), sizeof(desc));
                PlayerTextDrawSetString(playerid, MdcGui_cr_Description[i], desc);
            }

            PlayerTextDrawShow(playerid, MdcGui_cr_Type[i]);
            PlayerTextDrawShow(playerid, MdcGui_cr_Description[i]);
            PlayerTextDrawShow(playerid, MdcGui_cr_Date[i]);
            TextDrawShowForPlayer(playerid, MdcGui_cr_Info[i]);
        }
    }

    SelectTextDraw(playerid, -1);
}

DB:MdcSearchLicensePlate(playerid, plate[])
{
    if (GetDBNumRows() > 0)
    {
        new name[MAX_PLAYER_NAME];
        GetDBStringField(0, "owner", name);
        SetPVarString(playerid, "mdc_Citizen", name);
        mdc_ShowVehicle(playerid, GetNameWithSpace(name), GetDBIntField(0, "modelid") , GetDBIntField(0, "color1"), GetDBIntField(0, "color2"),
                        plate, false);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "No vehicle could be found under the mentioned license plate number.");
        Dialog_Show(playerid, DIALOG_MDC_SEARCH_PLATE, DIALOG_STYLE_INPUT, "{3D62A8}Search License Plate", "Please enter the license plate below:", "Search", "Cancel");
    }
}

DB:MdcFetchVehicle(playerid, owner[])
{
    mdc_Hide(playerid, false);
    if (GetDBNumRows() > 0)
    {
        if (GetPVarInt(playerid, "mdc_VehicleIndex") >= GetDBNumRows())
        {
            SetPVarInt(playerid, "mdc_VehicleIndex", 0);
        }

        new row = GetPVarInt(playerid, "mdc_VehicleIndex"),
            plate[50];

        GetDBStringField(row, "plate", plate);
        if (GetDBNumRows() > 1)
        {
            mdc_ShowVehicle(playerid, GetNameWithSpace(owner), GetDBIntField(row, "modelid") , GetDBIntField(row, "color1"),
                            GetDBIntField(row, "color2"), plate, true);
        }
        else
        {
            mdc_ShowVehicle(playerid, GetNameWithSpace(owner), GetDBIntField(row, "modelid") , GetDBIntField(row, "color1"),
                            GetDBIntField(row, "color2"), plate, false);
        }
    }
    else
    {
        TextDrawShowForPlayer(playerid, MdcGui_veh_BoxNoEnt);
        TextDrawShowForPlayer(playerid, MdcGui_veh_InnerBoxNoEnt);
        TextDrawShowForPlayer(playerid, MdcGui_HeaderBox);
        TextDrawShowForPlayer(playerid, MdcGui_HeaderText);
        TextDrawShowForPlayer(playerid, MdcGui_Exit);
        TextDrawShowForPlayer(playerid, MdcGui_veh_TextNoEnt);
        TextDrawShowForPlayer(playerid, MdcGui_veh_Label);
    }

    SelectTextDraw(playerid, -1);
}

hook OP_ClickTextDraw(playerid, Text:clickedid)
{
    if (clickedid == INVALID_TEXT_DRAW) return 1; // block any invalid textdraws.
    if (clickedid == MdcGui_Exit)
    {
        mdc_Hide(playerid, true);
    }
    else if (clickedid == MdcGui_SectionText[0])
    {
        Dialog_Show(playerid, SearchCitizem, DIALOG_STYLE_INPUT, "{3D62A8}Search Citizen", "Please enter the citizen's full name below:", "Search", "Cancel");
    }
    else if (clickedid == MdcGui_SectionText[1])
    {
        Dialog_Show(playerid, DIALOG_MDC_SEARCH_SERIAL, DIALOG_STYLE_INPUT, "{3D62A8}Search Weapon Serial", "Please enter the weapons's serial number below:", "Search", "Cancel");
    }
    else if (clickedid == MdcGui_SectionText[2])
    {
        Dialog_Show(playerid, SearchPhoneNumber, DIALOG_STYLE_INPUT, "{3D62A8}Search Phone Number", "Please enter the phone number below:", "Search", "Cancel");
    }
    else if (clickedid == MdcGui_SectionText[3])
    {
        Dialog_Show(playerid, DIALOG_MDC_SEARCH_PLATE, DIALOG_STYLE_INPUT, "{3D62A8}Search License Plate", "Please enter the license plate below:", "Search", "Cancel");
    }
    else if (clickedid == MdcGui_CriminalRecord || clickedid == MdcGui_CriminalRecordArrow)
    {
        new name[MAX_PLAYER_NAME];
        GetPVarString(playerid, "mdc_Citizen", name, sizeof(name));
        mdc_ShowCriminalRecord(playerid, name);
    }
    else if (clickedid == MdcGui_Cases || clickedid == MdcGui_CasesArrow)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{3D62A8}Case Files", "{ffffff}The Los Santos Police Department's Mobile Data Computer is presently under \ndevelopment. We ask for your patience and understanding.\n\nSincerely,\n{a9c4e4}LSPD Tech. Department", "Close", "");
    }
    else if (clickedid == MdcGui_Properties || clickedid == MdcGui_PropertiesArrow)
    {
        Dialog_Show(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "{3D62A8}Property Data", "{ffffff}The Los Santos Police Department's Mobile Data Computer is presently under \ndevelopment. We ask for your patience and understanding.\n\nSincerely,\n{a9c4e4}LSPD Tech. Department", "Close", "");
    }
    else if (clickedid == MdcGui_Vehicles || clickedid == MdcGui_VehiclesArrow)
    {
        new name[MAX_PLAYER_NAME];
        GetPVarString(playerid, "mdc_Citizen", name, sizeof(name));
        mdc_ShowVehicles(playerid, name);
    }
    else if (clickedid == MdcGui_cr_ArrowUp)
    {
        new ScrollTop = GetPVarInt(playerid, "CR_ScrollTop");
        if (ScrollTop > 0)
        {
            ScrollTop -= 1;
            SetPVarInt(playerid, "CR_ScrollTop", ScrollTop);
            for (new i = 0; i < sizeof(MdcGui_cr_Info); i++)
            {
                PlayerTextDrawHide(playerid, MdcGui_cr_Type[i]);
                PlayerTextDrawHide(playerid, MdcGui_cr_Description[i]);
                PlayerTextDrawHide(playerid, MdcGui_cr_Date[i]);
                if (CriminalRecordData[playerid][i + ScrollTop][CR_Type] == RECORD_CHARGE)
                {
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Type[i], "Charge");
                    if (CriminalRecordData[playerid][i + ScrollTop][CR_Served] == 0)
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_RED);
                    }
                    else
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_WHITE);
                    }
                }
                else
                {
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Type[i], "Ticket");
                    if (CriminalRecordData[playerid][i + ScrollTop][CR_Paid] == 0)
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_RED);
                    }
                    else
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_WHITE);
                    }
                }

                PlayerTextDrawSetString(playerid, MdcGui_cr_Date[i], CriminalRecordData[playerid][i + ScrollTop][CR_Date]);
                if (strlen(CriminalRecordData[playerid][i + ScrollTop][CR_Description]) < 20)
                {
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Description[i], CriminalRecordData[playerid][i + ScrollTop][CR_Description]);
                }
                else
                {
                    new desc[25];
                    strmid(desc, CriminalRecordData[playerid][i + ScrollTop][CR_Description], 0, 20, 200);
                    strins(desc, "...", strlen(desc), sizeof(desc));
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Description[i], desc);
                }

                PlayerTextDrawShow(playerid, MdcGui_cr_Type[i]);
                PlayerTextDrawShow(playerid, MdcGui_cr_Description[i]);
                PlayerTextDrawShow(playerid, MdcGui_cr_Date[i]);
            }
        }
    }
    else if (clickedid == MdcGui_cr_ArrowDown)
    {
        new ScrollTop = GetPVarInt(playerid, "CR_ScrollTop");
        if (Iter_Count(RecordIterator[playerid]) > ScrollTop + 7)
        {
            ScrollTop += 1;
            SetPVarInt(playerid, "CR_ScrollTop", ScrollTop);
            for (new i = 0; i < sizeof(MdcGui_cr_Info); i++)
            {
                PlayerTextDrawHide(playerid, MdcGui_cr_Type[i]);
                PlayerTextDrawHide(playerid, MdcGui_cr_Description[i]);
                PlayerTextDrawHide(playerid, MdcGui_cr_Date[i]);
                if (CriminalRecordData[playerid][i + ScrollTop][CR_Type] == RECORD_CHARGE)
                {
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Type[i], "Charge");
                    if (CriminalRecordData[playerid][i + ScrollTop][CR_Served] == 0)
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_RED);
                    }
                    else
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_WHITE);
                    }
                }
                else
                {
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Type[i], "Ticket");
                    if (CriminalRecordData[playerid][i + ScrollTop][CR_Paid] == 0)
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_RED);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_RED);
                    }
                    else
                    {
                        PlayerTextDrawColor(playerid, MdcGui_cr_Type[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Description[i], COLOR_WHITE);
                        PlayerTextDrawColor(playerid, MdcGui_cr_Date[i], COLOR_WHITE);
                    }
                }

                PlayerTextDrawSetString(playerid, MdcGui_cr_Date[i], CriminalRecordData[playerid][i + ScrollTop][CR_Date]);
                if (strlen(CriminalRecordData[playerid][i + ScrollTop][CR_Description]) < 20)
                {
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Description[i], CriminalRecordData[playerid][i + ScrollTop][CR_Description]);
                }
                else
                {
                    new desc[25];
                    strmid(desc, CriminalRecordData[playerid][i + ScrollTop][CR_Description], 0, 20, 200);
                    strins(desc, "...", strlen(desc), sizeof(desc));
                    PlayerTextDrawSetString(playerid, MdcGui_cr_Description[i], desc);
                }

                PlayerTextDrawShow(playerid, MdcGui_cr_Type[i]);
                PlayerTextDrawShow(playerid, MdcGui_cr_Description[i]);
                PlayerTextDrawShow(playerid, MdcGui_cr_Date[i]);
            }
        }
    }
    else if (clickedid == MdcGui_cr_Info[0])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop"));
    }
    else if (clickedid == MdcGui_cr_Info[1])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop") + 1);
    }
    else if (clickedid == MdcGui_cr_Info[2])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop") + 2);
    }
    else if (clickedid == MdcGui_cr_Info[3])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop") + 3);
    }
    else if (clickedid == MdcGui_cr_Info[4])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop") + 4);
    }
    else if (clickedid == MdcGui_cr_Info[5])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop") + 5);
    }
    else if (clickedid == MdcGui_cr_Info[6])
    {
        mdc_ShowCriminalRecordDetails(playerid, GetPVarInt(playerid, "CR_ScrollTop") + 6);
    }
    else if (clickedid == MdcGui_veh_ArrowRight || clickedid == MdcGui_veh_Next)
    {
        new name[MAX_PLAYER_NAME];
        GetPVarString(playerid, "mdc_Citizen", name, sizeof(name));
        SetPVarInt(playerid, "mdc_VehicleIndex", GetPVarInt(playerid, "mdc_VehicleIndex") + 1);
        mdc_ShowVehicles(playerid, name);
    }
    return 1;
}

publish MDC_ListCharges(playerid)
{
    new rows = GetDBNumRows();

    if (!rows)
    {
        SendClientMessage(playerid, COLOR_GREY, "This player has no active charges on them.");
    }
    else
    {
        new chargedby[MAX_PLAYER_NAME], date[24], reason[128], string[512];

        string = "Charged by\tDate\tReason";

        for (new i = 0; i < rows; i ++)
        {
            GetDBStringField(i, "chargedby", chargedby);
            GetDBStringField(i, "date", date);
            GetDBStringField(i, "reason", reason);

            format(string, sizeof(string), "%s\n%s\t%s\t%s", string, chargedby, date, reason);
        }

        Dialog_Show(playerid, DIALOG_MDCCHARGES, DIALOG_STYLE_TABLIST_HEADERS, "Active charges:", string, "<<", "");
    }

    return 1;
}

publish MDC_ClearCharges(playerid)
{
    if (GetDBNumRows())
    {
        new username[MAX_PLAYER_NAME], id = PlayerData[playerid][pSelected];

        GetDBStringField(0, "username", username);

        DBQuery("DELETE FROM charges WHERE uid = %i", id);

        DBQuery("UPDATE "#TABLE_USERS" SET wantedlevel = 0 WHERE uid = %i", id);

        foreach(new i : Player)
        {
            if (!strcmp(GetPlayerNameEx(i), username))
            {
                SendClientMessageEx(i, COLOR_WHITE, "Your crimes were cleared by %s.", GetRPName(playerid));
                PlayerData[i][pWantedLevel] = 0;
            }
        }

        SendFactionMessage(PlayerData[playerid][pFaction], COLOR_OLDSCHOOL, "* HQ: %s %s has cleared %s's charges and wanted level.", FactionRanks[PlayerData[playerid][pFaction]][PlayerData[playerid][pFactionRank]], GetRPName(playerid), username);
    }
}

publish MDC_PlayerLookup(playerid, username[])
{
    if (!GetDBNumRows())
    {
        SendClientMessage(playerid, COLOR_GREY, "That player doesn't exist and therefore has no information to view.");
        Dialog_Show(playerid, DIALOG_PLAYERLOOKUP, DIALOG_STYLE_INPUT, "Player lookup", "Enter the full name of the player to lookup:", "Submit", "Cancel");
    }
    else
    {
        new string[200];

        PlayerData[playerid][pSelected] = GetDBIntField(0, "uid");

        format(string, sizeof(string),
            "Name: %s\n"\
            "Gender: %s\n"\
            "Age: %i years old\n"\
            "Crimes commited: %i\n"\
            "Times arrested: %i\n"\
            "Wanted level: %i/6\n"\
            "Drivers license: %s",
            username,
            GenderToString(GetDBIntField(0, "gender")),
            GetDBIntField(0, "age"),
            GetDBIntField(0, "crimes"),
            GetDBIntField(0, "arrested"),
            GetDBIntField(0, "wantedlevel"),
            GetDBIntField(0, "carlicense") ? ("Yes") : ("No"));
        Dialog_Show(playerid, DIALOG_MDCPLAYER1, DIALOG_STYLE_MSGBOX, "Player lookup", string, "Options", "Cancel");
    }
}

Dialog:DIALOG_MDC_SEARCH_SERIAL(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!IsNumeric(inputtext))
        {
            SendClientMessage(playerid, COLOR_GREY, "You have to enter a numeric weapon serial number.");
            Dialog_Show(playerid, DIALOG_MDC_SEARCH_SERIAL, DIALOG_STYLE_INPUT, "{3D62A8}Search Weapon Serial", "Please enter the weapons serial number below:", "Search", "Cancel");
        }
        else
        {
            DBFormat("SELECT `username`, `skin`, `age`, `gender`, `carlicense`, `gunlicense`, `job`, `phone` FROM `users` WHERE `WepSerial` = %d;", strval(inputtext));
            DBExecute("MdcSearchSerial", "i", playerid);
        }
    }
    else
    {
        SelectTextDraw(playerid, -1);
    }
    return 1;
}

Dialog:DIALOG_MDC_SEARCH_PLATE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        DBFormat("SELECT `modelid`, `color1`, `color2`, `owner` FROM `vehicles` WHERE `plate` = '%e';", inputtext);
        DBExecute("MdcSearchLicensePlate", "is", playerid, inputtext);
    }
    else
    {
        SelectTextDraw(playerid, -1);
    }
    return 1;
}

Dialog:SearchCitizem(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!IsValidUsername(inputtext))
        {
            return SendClientMessage(playerid, COLOR_GREY, "Invalid player name.");
        }
        mdc_SearchCitizen(playerid, inputtext);
    }
    else
    {
        SelectTextDraw(playerid, -1);
    }
    return 1;
}

Dialog:SearchPhoneNumber(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (!IsNumeric(inputtext))
        {
            SendClientMessage(playerid, COLOR_GREY, "You have to enter a valid numeric phone number.");
            Dialog_Show(playerid, SearchPhoneNumber, DIALOG_STYLE_INPUT, "{3D62A8}Search Phone Number", "Please enter the phone number below:", "Search", "Cancel");
        }
        else
        {
            DBFormat("SELECT `username`, `skin`, `age`, `gender`, `carlicense`, `gunlicense`, `job` FROM `users` WHERE `phone` = %i;", strval(inputtext));
            DBExecute("MdcSearchPhoneNumber", "ii", playerid, strval(inputtext));
        }
    }
    else
    {
        SelectTextDraw(playerid, -1);
    }
    return 1;
}


CMD:mdc(playerid, params[])
{
    if (!IsLawEnforcement(playerid) && GetPlayerFaction(playerid) != FACTION_GOVERNMENT)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You have to be a police officer or government official to access the Mobile Data Computer.");
    }

    if (GetPVarInt(playerid, "mdc_shown") != 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You already have the Mobile Data Computer opened (Reminder: Use /cursor to get your cursor back active).");
    }

    if (IsPlayerNearMDC(playerid))
    {
        mdc_ShowPlayerStartScreen(playerid);
        SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Press ESC to disable the cursor and use /cursor to get your cursor back active.");
        SetPVarInt(playerid, "mdc_shown", 1);
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, "You are not close to a computer of the Los Santos Police Department and are not in a government vehicle equipped with a Mobile Data Computer.");
    }

    return 1;
}
