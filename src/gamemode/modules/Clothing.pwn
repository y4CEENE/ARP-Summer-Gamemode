/// @file      Clothing.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


DB:LoadClothing(playerid)
{
    new rows = GetDBNumRows();
    for (new i = 0; i < rows && i < MAX_PLAYER_CLOTHING; i ++)
    {
        GetDBStringField(i, "name", ClothingInfo[playerid][i][cName], 32);

        ClothingInfo[playerid][i][cID] = GetDBIntField(i, "id");
        ClothingInfo[playerid][i][cModel] = GetDBIntField(i, "modelid");
        ClothingInfo[playerid][i][cBone] = GetDBIntField(i, "boneid");
        ClothingInfo[playerid][i][cAttached] = GetDBIntField(i, "attached");
        ClothingInfo[playerid][i][cPosX] = GetDBFloatField(i, "pos_x");
        ClothingInfo[playerid][i][cPosY] = GetDBFloatField(i, "pos_y");
        ClothingInfo[playerid][i][cPosZ] = GetDBFloatField(i, "pos_z");
        ClothingInfo[playerid][i][cRotX] = GetDBFloatField(i, "rot_x");
        ClothingInfo[playerid][i][cRotY] = GetDBFloatField(i, "rot_y");
        ClothingInfo[playerid][i][cRotZ] = GetDBFloatField(i, "rot_z");
        ClothingInfo[playerid][i][cScaleX] = GetDBFloatField(i, "scale_x");
        ClothingInfo[playerid][i][cScaleY] = GetDBFloatField(i, "scale_y");
        ClothingInfo[playerid][i][cScaleZ] = GetDBFloatField(i, "scale_z");
        ClothingInfo[playerid][i][cExists] = 1;
        ClothingInfo[playerid][i][cAttachedIndex] = -1;
    }

    PlayerData[playerid][pAwaitingClothing] = 1;
}

Dialog:DIALOG_BUYCLOTHINGTYPE(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        PlayerData[playerid][pMenuType] = listitem;

        if (listitem == 0)
            ShowClothingSelectionMenu(playerid);
        else
            ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHING);
    }
    else
    {
        callcmd::buy(playerid, "\1");
    }
    return 1;
}
Dialog:DIALOG_BUYCLOTHING(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        PreviewClothing(playerid, listitem + PlayerData[playerid][pClothingIndex]);
    }
    else
    {
        ShowDialogToPlayer(playerid, DIALOG_BUYCLOTHINGTYPE);
    }
    return 1;
}
Dialog:DIALOG_CLOTHING(playerid, response, listitem, inputtext[])
{
    if (response && listitem >= 0)
    {
        if (!ClothingInfo[playerid][listitem][cExists])
        {
            return SendClientMessage(playerid, COLOR_GREY, "The slot you've selected does not contain any item of clothing.");
        }

        if (ClothingInfo[playerid][listitem][cAttached])
        {
            Dialog_Show(playerid, DIALOG_CLOTHINGMENU, DIALOG_STYLE_LIST, ClothingInfo[playerid][listitem][cName], "Detach\nEdit\nDelete", "Select", "Cancel");
        }
        else
        {
            Dialog_Show(playerid, DIALOG_CLOTHINGMENU, DIALOG_STYLE_LIST, ClothingInfo[playerid][listitem][cName], "Attach\nEdit\nDelete", "Select", "Cancel");
        }

        PlayerData[playerid][pSelected] = listitem;
    }
    return 1;
}
Dialog:DIALOG_CLOTHINGMENU(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        new clothingid = PlayerData[playerid][pSelected];

        switch (listitem)
        {
            case 0:
            {
                if (!ClothingInfo[playerid][clothingid][cAttached])
                {
                    ClothingInfo[playerid][clothingid][cAttachedIndex] = GetAvailableAttachedSlot(playerid);

                    if (ClothingInfo[playerid][clothingid][cAttachedIndex] >= 0)
                    {
                        ClothingInfo[playerid][clothingid][cAttached] = 1;

                        SetPlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex], ClothingInfo[playerid][clothingid][cModel], ClothingInfo[playerid][clothingid][cBone], ClothingInfo[playerid][clothingid][cPosX], ClothingInfo[playerid][clothingid][cPosY], ClothingInfo[playerid][clothingid][cPosZ], ClothingInfo[playerid][clothingid][cRotX], ClothingInfo[playerid][clothingid][cRotY], ClothingInfo[playerid][clothingid][cRotZ],
                            ClothingInfo[playerid][clothingid][cScaleX], ClothingInfo[playerid][clothingid][cScaleY], ClothingInfo[playerid][clothingid][cScaleZ]);
                        SendClientMessageEx(playerid, COLOR_WHITE, "%s attached to slot %i/5.", ClothingInfo[playerid][clothingid][cName], ClothingInfo[playerid][clothingid][cAttachedIndex] + 1);

                        DBQuery("UPDATE clothing SET attached = 1 WHERE id = %i", ClothingInfo[playerid][clothingid][cID]);

                        for (new i = 0, count = 0; i < MAX_PLAYER_CLOTHING; i ++)
                        {
                            if (ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
                            {
                                count++;

                                if (count == 5)
                                {
                                    AwardAchievement(playerid, ACH_DressUp);
                                }
                            }
                        }
                    }
                    else
                    {
                        SendClientMessage(playerid, COLOR_GREY, "No attachment slots available. You can only have up to five clothing items attached at once.");
                    }
                }
                else
                {
                    RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
                    ClothingInfo[playerid][clothingid][cAttached] = 0;
                    ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;

                    DBQuery("UPDATE clothing SET attached = 0 WHERE id = %i", ClothingInfo[playerid][clothingid][cID]);

                    SendClientMessageEx(playerid, COLOR_WHITE, "%s detached and added to inventory.", ClothingInfo[playerid][clothingid][cName]);
                }
            }
            case 1:
            {
                Dialog_Show(playerid, DIALOG_CLOTHINGEDIT, DIALOG_STYLE_LIST, "Edition menu", "Editor\nEdit coordination\nChange bone", "Select", "Cancel");
            }
            case 2:
            {
                RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][clothingid][cAttachedIndex]);
                SendClientMessageEx(playerid, COLOR_WHITE, "%s deleted from your clothing inventory.", ClothingInfo[playerid][clothingid][cName]);

                DBQuery("DELETE FROM clothing WHERE id = %i", ClothingInfo[playerid][clothingid][cID]);

                ClothingInfo[playerid][clothingid][cAttached] = 0;
                ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;
                ClothingInfo[playerid][clothingid][cExists] = 0;
                ClothingInfo[playerid][clothingid][cID] = 0;
                ClothingInfo[playerid][clothingid][cName] = 0;
            }
        }
    }
    return 1;
}

Dialog:DIALOG_CLOTHINGEDIT(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                PlayerData[playerid][pEditType] = EDIT_CLOTHING;

                if (!ClothingInfo[playerid][PlayerData[playerid][pSelected]][cAttached])
                {
                    SetPlayerAttachedObject(playerid, 9,
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cModel],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cBone],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosX],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosY],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosZ],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotX],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotY],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotZ],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleX],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleY],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleZ]);

                    EditAttachedObject(playerid, 9);
                }
                else
                {
                    EditAttachedObject(playerid, ClothingInfo[playerid][PlayerData[playerid][pSelected]][cAttachedIndex]);
                }

                GameTextForPlayer(playerid, "~w~Editing Mode~n~~g~Click disk to save~n~~r~Press ESC to cancel", 5000, 1);
            }
            case 1:
            {
                Dialog_Show(playerid, EditClothingCoords, DIALOG_STYLE_LIST, "Edition menu",
                        "Offset X (%.2f)\n"\
                        "Offset Y (%.2f)\n"\
                        "Offset Z (%.2f)\n"\
                        "Rotation X (%.2f)\n"\
                        "Rotation Y (%.2f)\n"\
                        "Rotation Z (%.2f)\n"\
                        "Scale X (%.2f)\n"\
                        "Scale Y (%.2f)\n"\
                        "Scale Z (%.2f)",
                        "Select", "Cancel",
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosX],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosY],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosZ],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotX],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotY],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotZ],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleX],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleY],
                        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleZ]);
            }
            case 2:
            {
                Dialog_Show(playerid, DIALOG_CLOTHINGBONE, DIALOG_STYLE_LIST, "Choose a new bone for this clothing item.", "Spine\nHead\nLeft upper arm\nRight upper arm\nLeft hand\nRight hand\nLeft thigh\nRight thigh\nLeft foot\nRight foot\nRight calf\nLeft calf\nLeft forearm\nRight forearm\nLeft shoulder\nRight shoulder\nNeck\nJaw", "Select", "Cancel");
            }
        }
    }
    return 1;
}

Dialog:EditClothingCoords(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        PlayerData[playerid][pSelectedStep2] = listitem;
        Dialog_Show(playerid, EditClothingCoords2, DIALOG_STYLE_INPUT, "Edition menu", "Enter new value: ", "Submit", "Cancel");
    }
    return 1;
}

Dialog:EditClothingCoords2(playerid, response, listitem, inputtext[])
{
    if (response && !isnull(inputtext))
    {
        new Float:newval = floatstr(inputtext);
        if (PlayerData[playerid][pSelectedStep2] >= 6)
        {
            if (newval <= 0.0)
                newval = 1.0;
            else if (newval > 3.0)
                newval = 3.0;
        }
        else if (PlayerData[playerid][pSelectedStep2] <= 2)
        {
            if (newval <= -1.0)
                newval = -1.0;
            else if (newval > 1.0)
                newval = 1.0;
        }

        new cidx = PlayerData[playerid][pSelected];
        switch (PlayerData[playerid][pSelectedStep2])
        {
            case 0: ClothingInfo[playerid][cidx][cPosX]   = newval;
            case 1: ClothingInfo[playerid][cidx][cPosY]   = newval;
            case 2: ClothingInfo[playerid][cidx][cPosZ]   = newval;
            case 3: ClothingInfo[playerid][cidx][cRotX]   = newval;
            case 4: ClothingInfo[playerid][cidx][cRotY]   = newval;
            case 5: ClothingInfo[playerid][cidx][cRotZ]   = newval;
            case 6: ClothingInfo[playerid][cidx][cScaleX] = newval;
            case 7: ClothingInfo[playerid][cidx][cScaleY] = newval;
            case 8: ClothingInfo[playerid][cidx][cScaleZ] = newval;
        }

        DBQuery("UPDATE clothing SET "\
            "pos_x = '%f', pos_y = '%f', pos_z = '%f'"\
            ", rot_x = '%f', rot_y = '%f', rot_z = '%f'"\
            ", scale_x = '%f', scale_y = '%f', scale_z = '%f'"\
            " WHERE id = %i",
            ClothingInfo[playerid][cidx][cPosX],
            ClothingInfo[playerid][cidx][cPosY],
            ClothingInfo[playerid][cidx][cPosZ],
            ClothingInfo[playerid][cidx][cRotX],
            ClothingInfo[playerid][cidx][cRotY],
            ClothingInfo[playerid][cidx][cRotZ],
            ClothingInfo[playerid][cidx][cScaleX],
            ClothingInfo[playerid][cidx][cScaleY],
            ClothingInfo[playerid][cidx][cScaleZ],
            ClothingInfo[playerid][cidx][cID]);

        if (!ClothingInfo[playerid][cidx][cAttached])
        {
            return SendClientMessage(playerid, COLOR_GREY, "Clothing position has been updated. Attach it to see results.");
        }

        RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][cidx][cAttachedIndex]);
        SetPlayerAttachedObject(playerid,
            ClothingInfo[playerid][cidx][cAttachedIndex],
            ClothingInfo[playerid][cidx][cModel],
            ClothingInfo[playerid][cidx][cBone],
            ClothingInfo[playerid][cidx][cPosX],
            ClothingInfo[playerid][cidx][cPosY],
            ClothingInfo[playerid][cidx][cPosZ],
            ClothingInfo[playerid][cidx][cRotX],
            ClothingInfo[playerid][cidx][cRotY],
            ClothingInfo[playerid][cidx][cRotZ],
            ClothingInfo[playerid][cidx][cScaleX],
            ClothingInfo[playerid][cidx][cScaleY],
            ClothingInfo[playerid][cidx][cScaleZ]);
    }
    return 1;
}

Dialog:DIALOG_CLOTHINGBONE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        ClothingInfo[playerid][PlayerData[playerid][pSelected]][cBone] = listitem + 1;

        if (ClothingInfo[playerid][PlayerData[playerid][pSelected]][cAttached])
        {
            RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerData[playerid][pSelected]][cAttachedIndex]);
            SetPlayerAttachedObject(playerid, ClothingInfo[playerid][PlayerData[playerid][pSelected]][cAttachedIndex], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cModel], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosX], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosY], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cPosZ],
                ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotX], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotY], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cRotZ], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleX], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleY], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cScaleZ]);
        }

        DBQuery("UPDATE clothing SET boneid = %i WHERE id = %i", ClothingInfo[playerid][PlayerData[playerid][pSelected]][cBone], ClothingInfo[playerid][PlayerData[playerid][pSelected]][cID]);

        SendClientMessageEx(playerid, COLOR_WHITE, "Bone for {00AA00}%s{FFFFFF} changed to '%s'.", ClothingInfo[playerid][PlayerData[playerid][pSelected]][cName], inputtext);
    }
    return 1;
}


PreviewClothing(playerid, index)
{
    if (PlayerData[playerid][pCash] < clothingArray[index][clothingPrice])
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't purchase this. You don't have enough money for it.");
    }
    if (IsMobile(playerid))
    {
        // Save
        new businessid = GetInsideBusiness(playerid);

        if (businessid >= 0 && BusinessInfo[businessid][bType] == BUSINESS_CLOTHES)
        {
            for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
            {
                if (!ClothingInfo[playerid][i][cExists])
                {
                    ClothingInfo[playerid][i][cModel] = clothingArray[index][clothingModel];
                    ClothingInfo[playerid][i][cBone] = clothingArray[index][clothingBone];
                    ClothingInfo[playerid][i][cPosX] = 0.0;
                    ClothingInfo[playerid][i][cPosY] = 0.0;
                    ClothingInfo[playerid][i][cPosZ] = 0.0;
                    ClothingInfo[playerid][i][cRotX] = 0.0;
                    ClothingInfo[playerid][i][cRotY] = 0.0;
                    ClothingInfo[playerid][i][cRotZ] = 0.0;
                    ClothingInfo[playerid][i][cScaleX] = 1.0;
                    ClothingInfo[playerid][i][cScaleY] = 1.0;
                    ClothingInfo[playerid][i][cScaleZ] = 1.0;
                    DBFormat("INSERT INTO clothing VALUES(null, %i, '%e', %i, %i, 0, '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
                            PlayerData[playerid][pID],
                            clothingArray[index][clothingName],
                            ClothingInfo[playerid][i][cModel],
                            ClothingInfo[playerid][i][cBone],
                            ClothingInfo[playerid][i][cPosX],
                            ClothingInfo[playerid][i][cPosY],
                            ClothingInfo[playerid][i][cPosZ],
                            ClothingInfo[playerid][i][cRotX],
                            ClothingInfo[playerid][i][cRotY],
                            ClothingInfo[playerid][i][cRotZ],
                            ClothingInfo[playerid][i][cScaleX],
                            ClothingInfo[playerid][i][cScaleY],
                            ClothingInfo[playerid][i][cScaleZ]);
                    DBExecute("OnPlayerBuyClothingItem", "isiii", playerid, clothingArray[index][clothingName], clothingArray[index][clothingPrice], businessid, i);
                    return 1;
                }
            }

            SendClientMessage(playerid, COLOR_GREY, "You have no more clothing slots available. Therefore you can't buy this.");
        }
    }
    else
    {
        SetPlayerAttachedObject(playerid, 9, clothingArray[index][clothingModel], clothingArray[index][clothingBone]);

        PlayerData[playerid][pEditType] = EDIT_CLOTHING_PREVIEW;
        PlayerData[playerid][pSelected] = index;

        SendClientMessageEx(playerid, COLOR_AQUA, "You are now previewing {FF6347}%s{33CCFF}. This clothing item costs {00AA00}%s{33CCFF} to purchase.", clothingArray[index][clothingName], FormatCash(clothingArray[index][clothingPrice]));
        SendClientMessageEx(playerid, COLOR_AQUA, "Use your cursor to control the editor interface. Click the floppy disk to save changes.");
        EditAttachedObject(playerid, 9);
    }
    return 1;
}

ShowClothingSelectionMenu(playerid)
{
    new
        models[MAX_SELECTION_MENU_ITEMS] = {-1, ...},
        index;

    PlayerData[playerid][pClothingIndex] = -1;

    for (new i = 0; i < sizeof(clothingArray); i ++)
    {
        if (!strcmp(clothingArray[i][clothingType], clothingTypes[PlayerData[playerid][pCategory]]))
        {
            if (PlayerData[playerid][pClothingIndex] == -1)
            {
                PlayerData[playerid][pClothingIndex] = i;
            }

            models[index++] = clothingArray[i][clothingModel];
        }
    }

    ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_CLOTHING, clothingTypes[PlayerData[playerid][pCategory]], models, index);
}

DB:OnPlayerAttachCopClothing(playerid, name[], clothingid)
{
    strcpy(ClothingInfo[playerid][clothingid][cName], name, 32);

    ClothingInfo[playerid][clothingid][cID] = GetDBInsertID();
    ClothingInfo[playerid][clothingid][cExists] = 1;
    ClothingInfo[playerid][clothingid][cAttached] = 0;
    ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;

    SendClientMessageEx(playerid, COLOR_AQUA, "%s added to clothing inventory. /clothing to attach your new item.", name);
}


DB:OnPlayerBuyClothingItem(playerid, name[], price, businessid, clothingid)
{
    new string[16];

    if (PlayerData[playerid][pTraderUpgrade] > 0)
    {
        price -= percent(price, (PlayerData[playerid][pTraderUpgrade] * 10));
        SendClientMessageEx(playerid, COLOR_YELLOW3, "Trader Perk: Your level %i/3 trader perk reduced the price of this item to $%i.", PlayerData[playerid][pTraderUpgrade], price);
    }

    strcpy(ClothingInfo[playerid][clothingid][cName], name, 32);

    ClothingInfo[playerid][clothingid][cID] = GetDBInsertID();
    ClothingInfo[playerid][clothingid][cExists] = 1;
    ClothingInfo[playerid][clothingid][cAttached] = 0;
    ClothingInfo[playerid][clothingid][cAttachedIndex] = -1;
    PerformBusinessPurchase(playerid, businessid, price);

    GivePlayerCash(playerid, -price);
    SendClientMessageEx(playerid, COLOR_AQUA, "%s purchased for {00AA00}$%i{33CCFF}. /clothing to find your new item.", name, price);
    SetPVarInt(playerid, "ColorToy", clothingid);
//  Dialog_Show(playerid, Clothing_MatColor1, DIALOG_STYLE_LIST, "Choose a layer.", "First\nSecond", "Select", "Close");
    format(string, sizeof(string), "~r~-$%i", price);
    GameTextForPlayer(playerid, string, 5000, 1);
}
GetAvailableAttachedSlot(playerid)
{
    for (new i = 0; i < 5; i ++)
    {
        if (!IsPlayerAttachedObjectSlotUsed(playerid, i))
        {
            return i;
        }
    }

    return -1;
}


SetPlayerClothing(playerid)
{
    // Reset any clothing that the player has on them.
    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
    {
        if (ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
        {
            RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex]);
        }
    }

    // Now, we reapply the clothing to the player.
    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
    {
        if (ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
        {
            if (ClothingInfo[playerid][i][cAttachedIndex] == -1)
            {
                ClothingInfo[playerid][i][cAttachedIndex] = GetAvailableAttachedSlot(playerid);
            }

            if (ClothingInfo[playerid][i][cAttachedIndex] >= 0)
            {
                SetPlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex], ClothingInfo[playerid][i][cModel], ClothingInfo[playerid][i][cBone], ClothingInfo[playerid][i][cPosX], ClothingInfo[playerid][i][cPosY], ClothingInfo[playerid][i][cPosZ], ClothingInfo[playerid][i][cRotX], ClothingInfo[playerid][i][cRotY], ClothingInfo[playerid][i][cRotZ], ClothingInfo[playerid][i][cScaleX], ClothingInfo[playerid][i][cScaleY], ClothingInfo[playerid][i][cScaleZ]);
            }
            else
            {
                // Clothing wasn't attached... slots are probably all full.
                ClothingInfo[playerid][i][cAttached] = 0;

                DBQuery("UPDATE clothing SET attached = 0 WHERE id = %i", ClothingInfo[playerid][i][cID]);
            }
        }
    }

    PlayerData[playerid][pAwaitingClothing] = 0;
}

ShowCopClothingMenu(playerid)
{
    new models[sizeof(copClothing)];

    for (new i = 0; i < sizeof(copClothing); i ++)
    {
        models[i] = copClothing[i][cModel];
    }

    ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_COPCLOTHING, "LEO Clothing", models, sizeof(models));
}

CMD:toys(playerid, params[])
{
    return callcmd::clothing(playerid, params);
}

CMD:clothing(playerid, params[])
{
    new string[MAX_PLAYER_CLOTHING * 64], title[64], count;

    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
    {
        if (i != 0)
        {
            format(string, sizeof(string), "%s\n", string);
        }

        if (ClothingInfo[playerid][i][cExists])
        {
            if (ClothingInfo[playerid][i][cAttached])
            {
                format(string, sizeof(string), "%s{C8C8C8}%i) {00AA00}%s {FFD700}(Attached)", string, i + 1, ClothingInfo[playerid][i][cName]);
            }
            else
            {
                format(string, sizeof(string), "%s{C8C8C8}%i) {00AA00}%s{FFFFFF}", string, i + 1, ClothingInfo[playerid][i][cName]);
            }

            count++;
        }
        else
        {
            format(string, sizeof(string), "%s{C8C8C8}%i) {AFAFAF}Empty Slot{FFFFFF}", string, i + 1);
        }
    }

    format(title, sizeof(title), "My clothing items (%i/%i slots)", count, MAX_PLAYER_CLOTHING);
    Dialog_Show(playerid, DIALOG_CLOTHING, DIALOG_STYLE_LIST, title, string, "Select", "Cancel");
    return 1;
}
CMD:wat(playerid, params[])
{
    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
    {
        ClothingInfo[playerid][i][cAttached] = 1;
        SetPlayerClothing(playerid);
    }
}

CMD:dat(playerid, params[])
{
    for (new i = 0; i < MAX_PLAYER_CLOTHING; i ++)
    {
        if (ClothingInfo[playerid][i][cExists] && ClothingInfo[playerid][i][cAttached])
        {
            RemovePlayerAttachedObject(playerid, ClothingInfo[playerid][i][cAttachedIndex]);
        }
    }
}
