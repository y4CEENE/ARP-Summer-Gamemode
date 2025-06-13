/// @file      AccountSettings.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-14 14:22:02 +0200
/// @copyright Copyright (c) 2022


Dialog:DIALOG_SETTINGS2(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                if (!PlayerData[playerid][pTogglePM])
                {
                    PlayerData[playerid][pTogglePM] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "PM toggled. You will no longer receive any private message from players.");
                }
                else
                {
                    PlayerData[playerid][pTogglePM] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "PM enabled. You will now receive private message from players again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 1:
            {
                if (!PlayerData[playerid][pDonator])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You are not a VIP member and therefore cannot toggle this feature.");
                }

                if (!PlayerData[playerid][pToggleVIP])
                {
                    PlayerData[playerid][pToggleVIP] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "VIP chat toggled. You will no longer see any messages in VIP chat.");
                }
                else
                {
                    PlayerData[playerid][pToggleVIP] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "VIP chat enabled. You will now see messages in VIP chat again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 2:
            {
                if (PlayerData[playerid][pFaction] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction and therefore can't toggle this chat.");
                }

                if (!PlayerData[playerid][pToggleFaction])
                {
                    PlayerData[playerid][pToggleFaction] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Faction chat toggled. You will no longer see any messages in faction chat.");
                }
                else
                {
                    PlayerData[playerid][pToggleFaction] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Faction chat enabled. You will now see messages in faction chat again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 3:
            {
                if (PlayerData[playerid][pGang] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You are not a gang member and therefore can't toggle this chat.");
                }

                if (!PlayerData[playerid][pToggleGang])
                {
                    PlayerData[playerid][pToggleGang] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Gang chat toggled. You will no longer see any messages in gang chat.");
                }
                else
                {
                    PlayerData[playerid][pToggleGang] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Gang chat enabled. You will now see messages in gang chat again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 4:
            {
                if (!PlayerData[playerid][pToggleCam])
                {
                    PlayerData[playerid][pToggleCam] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Spawn camera toggled. You will no longer see the camera effects upon spawning.");
                }
                else
                {
                    PlayerData[playerid][pToggleCam] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Spawn camera enabled. You will now see the camera effects when you spawn again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 5:
            {
                if (!PlayerData[playerid][pToggleHUD])
                {
                    PlayerData[playerid][pToggleHUD] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "HUD toggled. You will no longer see your health & armor indicators.");

                    PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
                    PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);

                }
                else
                {
                    PlayerData[playerid][pToggleHUD] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "HUD enabled. You will now see your health & armor indicators again.");

                    PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
                    PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 6:
            {
                if (!PlayerData[playerid][pToggleVehCam])
                {
                    PlayerData[playerid][pToggleVehCam] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "One Seat Driving Person toggled.");


                }
                else
                {
                    PlayerData[playerid][pToggleVehCam] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "On Seat Driving Person enabled.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
            }
            case 7: ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
        }
    }
    return 1;
}
Dialog:DIALOG_SETTINGS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0:
            {
                if (!PlayerData[playerid][pToggleTextdraws])
                {
                    PlayerTextDrawHide(playerid, PlayerData[playerid][pGPSText]);
                    PlayerTextDrawHide(playerid, PlayerData[playerid][pArmorText]);
                    PlayerTextDrawHide(playerid, PlayerData[playerid][pHealthText]);
                    TextDrawHideForPlayer(playerid, TimeTD);
                    PlayerData[playerid][pToggleTextdraws] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Textdraws toggled. You will no longer see any textdraws.");
                }
                else
                {
                    if (PlayerData[playerid][pGPSOn])
                    {
                        PlayerTextDrawShow(playerid, PlayerData[playerid][pGPSText]);
                    }
                    if (PlayerData[playerid][pWatchOn])
                    {
                        TextDrawShowForPlayer(playerid, TimeTD);
                    }
                    if (!PlayerData[playerid][pToggleHUD])
                    {
                        PlayerTextDrawShow(playerid, PlayerData[playerid][pArmorText]);
                        PlayerTextDrawShow(playerid, PlayerData[playerid][pHealthText]);
                    }


                    PlayerData[playerid][pToggleTextdraws] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Textdraws enabled. You will now see textdraws again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 1:
            {
                if (!PlayerData[playerid][pToggleOOC])
                {
                    PlayerData[playerid][pToggleOOC] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "OOC chat toggled. You will no longer see any messages in /o.");
                }
                else
                {
                    PlayerData[playerid][pToggleOOC] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "OOC chat enabled. You will now see messages in /o again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 2:
            {
                if (!PlayerData[playerid][pToggleGlobal])
                {
                    PlayerData[playerid][pToggleGlobal] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Global chat toggled. You will no longer see any messages in /g.");
                }
                else
                {
                    PlayerData[playerid][pToggleGlobal] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Global chat enabled. You can now speak to other players in /g.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 3:
            {
                if (!PlayerData[playerid][pTogglePhone])
                {
                    if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
                    {
                        return SendClientMessage(playerid, COLOR_GREY, "You can't do this while in a call.");
                    }

                    PlayerData[playerid][pTogglePhone] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Phone toggled. You will no longer receive calls or texts.");
                }
                else
                {
                    PlayerData[playerid][pTogglePhone] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Phone enabled. You can now receive calls and texts again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 4:
            {
                if (!PlayerData[playerid][pToggleWhisper])
                {
                    PlayerData[playerid][pToggleWhisper] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Whispers toggled. You will no longer receive any whispers from players.");
                }
                else
                {
                    PlayerData[playerid][pToggleWhisper] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Whispers enabled. You will now receive whispers from players again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 5:
            {
                if (!PlayerData[playerid][pToggleNewbie])
                {
                    PlayerData[playerid][pToggleNewbie] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Newbie chat toggled. You will no longer see any messages in newbie chat.");
                }
                else
                {
                    PlayerData[playerid][pToggleNewbie] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Newbie chat enabled. You will now see messages in newbie chat again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 6:
            {
                if (!PlayerData[playerid][pPrivateRadio])
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You don't have a private radio.");
                }

                if (!PlayerData[playerid][pTogglePR])
                {
                    PlayerData[playerid][pTogglePR] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Private radio toggled. You will no longer receive any messages on your private radio.");
                }
                else
                {
                    PlayerData[playerid][pTogglePR] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Private radio enabled. You will now receive messages on your private radio again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 7:
            {
                if (PlayerData[playerid][pFaction] == -1)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "You are not apart of a faction and therefore can't toggle your radio.");
                }

                if (!PlayerData[playerid][pToggleRadio])
                {
                    PlayerData[playerid][pToggleRadio] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "Radio chat toggled. You will no longer receive any messages on your radio.");
                }
                else
                {
                    PlayerData[playerid][pToggleRadio] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Radio chat enabled. You will now receive messages on your radio again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 8:
            {
                if (!PlayerData[playerid][pToggleMusic])
                {
                    PlayerData[playerid][pToggleMusic] = 1;
                    StopAudioStreamForPlayer(playerid);
                    SendClientMessage(playerid, COLOR_AQUA, "Music streams toggled. You will no longer hear any music played locally & globally.");
                }
                else
                {
                    PlayerData[playerid][pToggleMusic] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "Music streams enabled. You will now hear music played locally & globally again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 9:
            {
                if (!PlayerData[playerid][pToggleNews])
                {
                    PlayerData[playerid][pToggleNews] = 1;
                    SendClientMessage(playerid, COLOR_AQUA, "News chat toggled. You will no longer see any news broadcasts.");
                }
                else
                {
                    PlayerData[playerid][pToggleNews] = 0;
                    SendClientMessage(playerid, COLOR_AQUA, "News chat enabled. You will now see news broadcasts again.");
                }
                ShowDialogToPlayer(playerid, DIALOG_SETTINGS);
            }
            case 10: ShowDialogToPlayer(playerid, DIALOG_SETTINGS2);
        }
    }
    return 1;
}

Dialog:DIALOG_CHANGEPASS(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (strlen(inputtext) < 4)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You need to enter a password greater than 4 characters.");
        }
        if (IsCommonPassword(inputtext))
        {
            return SendClientMessage(playerid, COLOR_LIGHTRED, "* This a very common password please choose another one.");
        }

        new password[129];

        WP_Hash(password, sizeof(password), inputtext);

        DBQuery("UPDATE "#TABLE_USERS" SET password = '%e', passwordchanged = '1' WHERE uid = %i", password, PlayerData[playerid][pID]);

        SendClientMessage(playerid, COLOR_WHITE, "Your account password was changed successfully.");
    }
    return 1;
}

Dialog:DIALOG_FREENAMECHANGE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (isnull(inputtext))
        {
            if (!IsPlayerLoggedIn(playerid))
            {
                KickPlayer(playerid, "Please reconnect with a proper roleplay name in the Firstname_Lastname format.", INVALID_PLAYER_ID, BAN_VISIBILITY_NONE);
                return 1;
            }
            return Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
        }
        if (!(3 <= strlen(inputtext) <= 20))
        {
            SendClientMessage(playerid, COLOR_GREY, "Your name must contain 3 to 20 characters.");
            return Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
        }
        if (strfind(inputtext, "_") == -1 || inputtext[strlen(inputtext)-1] == '_')
        {
            SendClientMessage(playerid, COLOR_GREY, "The name needs to contain at least one underscore.");
            return Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
        }
        if (!IsValidUsername(inputtext))
        {
            SendClientMessage(playerid, COLOR_GREY, "That name is not supported by SA-MP.");
            return Dialog_Show(playerid, DIALOG_FREENAMECHANGE, DIALOG_STYLE_INPUT, "Non-RP Name", "An administrator has came to the conclusion that your name is non-RP.\nTherefore you have been given this free namechange in order to correct it.\n\nEnter a name in the Firstname_Lastname format in the box below:", "Submit", "Cancel");
        }

        PlayerData[playerid][pFreeNamechange] = 1;

        DBFormat("SELECT uid FROM "#TABLE_USERS" WHERE username = '%e'", inputtext);
        DBExecute("OnPlayerAttemptNameChange", "is", playerid, inputtext);
    }
    else
    {
        if (!PlayerData[playerid][pLogged])
        {
            KickPlayer(playerid, "Failing to change their name.", INVALID_PLAYER_ID, BAN_VISIBILITY_ADMIN);
        }
        else
        {
            SetPlayerInJail(playerid, JailType_OOCPrison, 20 * 60, "Failing to change their name");

            SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s[%i] has been prisoned for failing to change their name.", GetRPName(playerid), playerid);
            LogPlayerPunishment(INVALID_PLAYER_ID, PlayerData[playerid][pID], GetPlayerIP(playerid),
                "PRISON", "%s has been prisoned by "#SERVER_ANTICHEAT" for 20 minutes, Reason: failing to change their name.",
                GetPlayerNameEx(playerid));
        }
    }
    return 1;
}

Dialog:DIALOG_NEWUPGRADEONE(playerid, response, listitem, inputtext[])
{
    if (response)
    {
        if (PlayerData[playerid][pUpgradePoints] < 1)
        {
            return SendClientMessage(playerid, COLOR_GREY, "You have no upgrade points available which you can spend.");
        }
        switch (listitem)
        {
            case 0:
            {
                if (PlayerData[playerid][pInventoryUpgrade] >= 5)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your inventory skill is already upgraded to its maximum level of 5.");
                }
                PlayerData[playerid][pInventoryUpgrade]++;
                PlayerData[playerid][pUpgradePoints]--;

                DBQuery("UPDATE "#TABLE_USERS" SET inventoryupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerData[playerid][pInventoryUpgrade], PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);

                SendClientMessageEx(playerid, COLOR_GREEN, "You upgraded your inventory skill to %i/5. Your inventory capacity was increased.", PlayerData[playerid][pInventoryUpgrade]);
            }
            case 1:
            {
                if (PlayerData[playerid][pAddictUpgrade] >= 3)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your addict skill is already upgraded to its maximum level of 3.");
                }

                PlayerData[playerid][pAddictUpgrade]++;
                PlayerData[playerid][pUpgradePoints]--;

                DBQuery("UPDATE "#TABLE_USERS" SET addictupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerData[playerid][pAddictUpgrade], PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);

                SendClientMessageEx(playerid, COLOR_GREEN, "You upgraded your addict skill to level %i/3. You now gain %.1f more health & armor when using drugs.", PlayerData[playerid][pAddictUpgrade], PlayerData[playerid][pAddictUpgrade] * 5.0);
            }
            case 2:
            {
                if (PlayerData[playerid][pTraderUpgrade] >= 3)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your trader skill is already upgraded to its maximum level of 3.");
                }

                PlayerData[playerid][pTraderUpgrade]++;
                PlayerData[playerid][pUpgradePoints]--;

                DBQuery("UPDATE "#TABLE_USERS" SET traderupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerData[playerid][pTraderUpgrade], PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);

                SendClientMessageEx(playerid, COLOR_GREEN, "You upgraded your trader skill to level %i/3. You now pay %i percent less for items in shops.", PlayerData[playerid][pTraderUpgrade], PlayerData[playerid][pTraderUpgrade] * 10);

            }
            case 3:
            {
                if (PlayerData[playerid][pAssetUpgrade] >= 4)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your asset skill is already upgraded to its maximum level of 4.");
                }

                PlayerData[playerid][pAssetUpgrade]++;
                PlayerData[playerid][pUpgradePoints]--;

                DBQuery("UPDATE "#TABLE_USERS" SET assetupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerData[playerid][pAssetUpgrade], PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);

                SendClientMessageEx(playerid, COLOR_GREEN, "You upgraded your asset skill to level %i/4. You can now own %i/%i houses and garages and %i/%i businesses and vehicles.", PlayerData[playerid][pAssetUpgrade], GetPlayerAssetLimit(playerid, LIMIT_HOUSES), GetPlayerAssetLimit(playerid, LIMIT_GARAGES), GetPlayerAssetLimit(playerid, LIMIT_BUSINESSES), GetPlayerAssetLimit(playerid, LIMIT_VEHICLES));

            }
            case 4:
            {
                if (PlayerData[playerid][pLaborUpgrade] >= 5)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your labor skill is already upgraded to its maximum level of 5.");
                }

                PlayerData[playerid][pLaborUpgrade]++;
                PlayerData[playerid][pUpgradePoints]--;

                DBQuery("UPDATE "#TABLE_USERS" SET laborupgrade = %i, upgradepoints = %i WHERE uid = %i", PlayerData[playerid][pLaborUpgrade], PlayerData[playerid][pUpgradePoints], PlayerData[playerid][pID]);

                SendClientMessageEx(playerid, COLOR_GREEN, "You upgraded your labor skill to level %i/5. You now earn %i percent more extra cash when you work.", PlayerData[playerid][pLaborUpgrade], PlayerData[playerid][pLaborUpgrade] * 2);

            }
            case 5:
            {
                if (PlayerData[playerid][pSpawnHealth] >= 100)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your spawn health is at maximum (100).");
                }

                PlayerData[playerid][pSpawnHealth] += 5.0;
                PlayerData[playerid][pUpgradePoints]--;

                SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your spawn health. You will now spawn with %.1f health after death.", PlayerData[playerid][pSpawnHealth]);

            }
            case 6:
            {
                if (PlayerData[playerid][pSpawnArmor] > 100 && PlayerData[playerid][pDonator] == 0)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your spawn armor is at maximum (100).");
                }
                else if (PlayerData[playerid][pSpawnArmor] > 125 && PlayerData[playerid][pDonator] <= 2)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your spawn armor is at maximum (125).");
                }
                else if (PlayerData[playerid][pSpawnArmor] > 150 && PlayerData[playerid][pDonator] == 3)
                {
                    return SendClientMessage(playerid, COLOR_GREY, "Your spawn armor is at maximum (150).");
                }

                PlayerData[playerid][pSpawnArmor] += 2.0;
                PlayerData[playerid][pUpgradePoints]--;

                SendClientMessageEx(playerid, COLOR_GREEN, "You have upgraded your spawn armor. You will now spawn with %.1f armor after death.", PlayerData[playerid][pSpawnArmor]);

            }
        }
        if (PlayerData[playerid][pInventoryUpgrade] == 5 || PlayerData[playerid][pAddictUpgrade] == 3 || PlayerData[playerid][pTraderUpgrade] == 3 || PlayerData[playerid][pAssetUpgrade] == 4 || PlayerData[playerid][pLaborUpgrade] == 5 || PlayerData[playerid][pSpawnHealth] == 100 || PlayerData[playerid][pSpawnArmor] == 100)
        {
            AwardAchievement(playerid, ACH_Benefits);
        }
    }
    return 1;
}
