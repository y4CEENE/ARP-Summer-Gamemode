/// @file      Roleplay.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2022-07-15 23:41:01 +0200
/// @copyright Copyright (c) 2022


CMD:rp(playerid, params[])
{
    new option[10];
    if (sscanf(params, "s[10]", option))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /rp [option]");
        SendClientMessage(playerid, COLOR_WHITE, "Guns: GrabGun, HideGun, AimHead, AimBody, AimFeet, AimHand");
        SendClientMessage(playerid, COLOR_WHITE, "Player: handsup, handsdown");
        if (GetPlayerFaction(playerid) == FACTION_POLICE && GetPlayerFaction(playerid) == FACTION_ARMY && GetPlayerFaction(playerid) == FACTION_FEDERAL)
        {
            SendClientMessage(playerid, COLOR_BLUE, "Police RP: Tazer");
        }
        if (GetPlayerFaction(playerid) == FACTION_MEDIC)
        {
            SendClientMessage(playerid, COLOR_DOCTOR, "Saving Patient Step: Rushpt, Stopbleed, Getst, Lowst, Rusham");
            SendClientMessage(playerid, COLOR_DOCTOR, "Medic RP: Heal");
        }
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendClientMessage(playerid, COLOR_GREEN, "OpenL, GetTools, CarHood, Nitro, Hyd, GetWheels, InWheel, BodyKits");
            SendClientMessage(playerid, COLOR_GREEN, "Install");
        }
        return 1;
    }
    if (!strcmp(option, "bodykits", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s attempts to install bodykits towards the car.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "inwheel", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s removes the old 4 wheels of the car as he/she installs new ones.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "getwheels", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s takes 4 pieces of wheels from the locker.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "hyd", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s attempts to install the Hydraulics to the car.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "nitro", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s attempts to install the nitro boost to the car.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "install", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** Installed. ((%s))", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "openl", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s opens the locker with his/her right hand.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "gettools", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s takes the tools/bodykits from the locker.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "carhood", true))
    {
        if (PlayerHasJob(playerid, JOB_MECHANIC))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s uses his/her force to open the car's hood.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "handsup", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s raises both of his/her hands onto the air, levels it at his/her head.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "rushpt", true))
    {
        if (GetPlayerFaction(playerid) == FACTION_MEDIC)
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s rushes towards the patient with the medkit.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "stopbleed", true))
    {
        if (GetPlayerFaction(playerid) == FACTION_MEDIC)
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s uses alcohol, cotton and bandage to stop the bleeding of the wound.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "getst", true))
    {
        if (GetPlayerFaction(playerid) == FACTION_MEDIC)
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s rushes at the back of the ambulance, taking out a stretcher and rushes back towards the patient.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "lowst", true))
    {
        if (GetPlayerFaction(playerid) == FACTION_MEDIC)
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s lowers the stretcher, levels it towards the patient and gently move the patient on it.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "rusham", true))
    {
        if (GetPlayerFaction(playerid) == FACTION_MEDIC)
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s rushes towards at the back of the ambulance, loading the patient inside.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }

    if (!strcmp(option, "handsdown", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s moves his hands down freely.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "grabgun", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s grabs his/her gun out, loads it and switches the safety to OFF.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "hidegun", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s hides/slings his/her gun back to its old position and flicking the safety to ON.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "aimhead", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s aims the gun at the head of the enemy.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "aimbody", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s aims the gun at the body of the enemy.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "aimfeet", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s aims the gun at the feet of the enemy.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "aimhand", true))
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s aims the gun at the hand of the enemy.", GetRPName(playerid));
        return 1;
    }
    if (!strcmp(option, "tazer", true))
    {
        if (IsLawEnforcement(playerid))
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s shoots the tazer towards the enemy.", GetRPName(playerid));
        }
        else SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        return 1;
    }
    if (!strcmp(option, "heal", true))
    {
        if (GetPlayerFaction(playerid) != FACTION_MEDIC)
        {
            SendClientMessage(playerid, COLOR_WHITE, "You are not allowed to use this command.");
        }
        else
        {
            SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s uses alcohol, cotton and bandage to cure the patient's wound.", GetRPName(playerid));
        }
        return 1;
    }
    return 1;
}
