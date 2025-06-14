#include <YSI\y_hooks>
// Car tunning menu v2.1, by HeLiOn PrImE

hook OnGameModeInit()
{    
	CreateDynamicPickup(1098, 23,  1961.0951, -1565.8511,13.7161);
	CreateDynamic3DTextLabel("/tune \nTo modify/tune your vehicle",COLOR_YELLOW, 1961.0951, -1565.8511, 13.7161+0.6,4.0);
	CreateDynamicPickup(1098, 23, -2116.5244,   -31.1166,36.6732);
	CreateDynamic3DTextLabel("/tune \nTo modify/tune your vehicle",COLOR_YELLOW,-2116.5244,   -31.1166, 36.6732+0.6,4.0);
    return 1;
}

CMD:tune(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 20.0,  1961.0951, -1565.8511,13.7161) &&
       !IsPlayerInRangeOfPoint(playerid, 20.0, -2116.5244,   -31.1166,36.6732))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not at mechanic job.");
    }

    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to drive your vehicle in order to tune it.");
    }
    if(!IsVehicleOwner(playerid, vehicleid))
    {
        return SendClientMessage(playerid, COLOR_GREY, "You need to drive your vehicle in order to tune it.");
    }
    if(!CanModCar(vehicleid))
    {
        return SendClientMessage(playerid,COLOR_RED,"You are not allowed to modify/tune this vehicle");
    }
    Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
    return 1;
}

//------------------------All car that are allowed to mod------------------------------------------------------------
// Put here all car's id's yo want to be modable
// NOTE: DO NOT TRY TO ALLOW OR MOD BOATS ; PLANES OR OTHER NON CARS.THAT WIL CAUSE YOUR SERVER CRASH
publish CanModCar(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);     

	switch(modelid) 
    {
        case 562,565,559,561,560,575,534,567,536,535,576,411,579,602,496,518,527,589,597,419,
		533,526,474,545,517,410,600,436,580,439,549,491,445,604,507,585,587,466,492,546,551,516,
		426, 547, 405, 409, 550, 566, 540, 421,	529,431,438,437,420,525,552,416,433,427,490,528,
		407,544,470,598,596,599,601,428,499,609,524,578,486,406,573,455,588,403,514,423,
		414,443,515,456,422,482,530,418,572,413,440,543,583,478,554,402,542,603,475,568,504,457,
        483,508,429,541,415,480,434,506,451,555,477,400,404,489,479,442,458,467,558,444: 
        {
 			return 1;
		}
	}
	return 0;
}

Dialog:DIALOG_TYPE_MAIN(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        switch(listitem)// Checking which list item was selected
        {
            case 0:// Paintjobs
            {
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            case 1: // colors
            {
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            case 2: // Hoods
            {
                Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
            }
            case 3: // Vents
            {
                Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
            }
            case 4: // Lights
            {
                Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
            }
            case 5: // Exhausts
            {
                Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
            }
            case 6: // Front Bumpers
            {
                Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
            }
            case 7: // Rear Bumpers
            {
                Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
            }
            case 8: // Roofs
            {
                Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
            }
            case 9: // Spoilers
            {
                Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
            }
            case 10: // Side Skirts
            {
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
            }
            case 11: // Bullbars
            {
                Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
            }
            case 12: // Wheels
            {
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            case 13: // Car Stereo
            {
                Dialog_Show(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
            }
            case 14: // Hydraulics
            {
                Dialog_Show(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
            }
            case 15: // Nitrous Oxide
            {
                Dialog_Show(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
            }
            case 16: // Repair Car
            {
                new car = GetPlayerVehicleID(playerid);
                SetVehicleHealth(car,1000);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repaired car");
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
                return 1;
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_PAINTJOBS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    

    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:// Paintjobs
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 560 ||
            modelid == 575 ||
            modelid == 534 || // Broadway
            modelid == 567 ||
            modelid == 536 ||
            modelid == 535 ||
            modelid == 576 ||
            modelid == 558)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehiclePaintjob(car,0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            }
            case 1: // Colors
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 560 ||
            modelid == 575 ||
            modelid == 534 || // Broadway
            modelid == 567 ||
            modelid == 536 ||
            modelid == 535 ||
            modelid == 576 ||
            modelid == 558)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehiclePaintjob(car,1);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            }
            case 2: // Exhausts
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 560 ||
            modelid == 575 ||
            modelid == 534 || // Broadway
            modelid == 567 ||
            modelid == 536 ||
            modelid == 535 ||
            modelid == 576 ||
            modelid == 558)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehiclePaintjob(car,2);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            }
            case 3: // Front Bumpers
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 560 ||
            modelid == 575 ||
            modelid == 534 || // Broadway
            modelid == 567 ||
            modelid == 536 ||
            modelid == 535 ||
            modelid == 576 ||
            modelid == 558)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehiclePaintjob(car,3);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            }
            case 4: // Rear Bumpers
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 560 ||
            modelid == 575 ||
            modelid == 534 || // Broadway
            modelid == 567 ||
            modelid == 536 ||
            modelid == 535 ||
            modelid == 576 ||
            modelid == 558)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehiclePaintjob(car,4);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added paintjob to car");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Paintjob is only for Wheel Arch Angrls and Loco Low Co types of cars");
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            }
            case 5:
            {
                Dialog_Show(playerid, DIALOG_TYPE_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5\n \nBack", "Apply", "Close");
            }
            case 6:
            {
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_COLORS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,0,0);
                //GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);

            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 1:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,1,1);
            //    GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 2:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,3,3);
                //  GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 3:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,79,79);
                //   GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 4:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,86,86);
                //   GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 5:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,6,6);
                //  GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 6:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,126,126);
            //      GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 7:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,66,66);
            //    GivePlayerMoney(playerid,-150);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 8:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,24,24);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 9:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,123,123);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 10:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,53,53);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 11:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,93,93);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 12:
            {
                    if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,83,83);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                    else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 13:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,60,60);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 14:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,161,161);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 15:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                ChangeVehicleColor(car,153,153);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully repainted to car");
                PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            }
            case 16:
            {
                Dialog_Show(playerid, DIALOG_TYPE_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown\n \nBack", "Apply", "Close");
            }
            case 17:
            {
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}

Dialog:DIALOG_TYPE_EXHAUSTS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 

        switch(listitem)
        {
            case 0:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 558 ||
            modelid == 561 ||
            modelid == 560)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562)
                {
                    AddVehicleComponent(car,1034);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565)
                {
                    AddVehicleComponent(car,1046);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559)
                {
                    AddVehicleComponent(car,1065);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561)
                {
                    AddVehicleComponent(car,1064);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560)
                {
                    AddVehicleComponent(car,1028);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558)
                {
                    AddVehicleComponent(car,1089);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
            }
            case 1:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562)
                {
                    AddVehicleComponent(car,1037);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565)
                {
                    AddVehicleComponent(car,1045);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559)
                {
                    AddVehicleComponent(car,1066);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561)
                {
                    AddVehicleComponent(car,1059);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560)
                {
                    AddVehicleComponent(car,1029);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558)
                {
                    AddVehicleComponent(car,1092);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
            }
            case 2:
            {
                if(modelid == 575 ||
            modelid == 534 ||
            modelid == 567 ||
            modelid == 536 ||
            modelid == 576 ||
            modelid == 535)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 575) // Brodway
                {
                    AddVehicleComponent(car,1044);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 534)// Remington
                {
                    AddVehicleComponent(car,1126);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 567)// Savanna
                {
                    AddVehicleComponent(car,1129);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1104);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1113);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 576) // Tornado
                {
                    AddVehicleComponent(car,1136);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
            }
            case 3:
            {
                if(modelid == 575 ||
            modelid == 534 ||
            modelid == 567 ||
            modelid == 536 ||
            modelid == 576 ||
            modelid == 535)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 575) // Brodway
                {
                    AddVehicleComponent(car,1043);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 534)// Remington
                {
                    AddVehicleComponent(car,1127);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 567)// Savanna
                {
                    AddVehicleComponent(car,1132);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
                else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1105);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }

                else if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1114);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }

                else if(modelid == 576) // Tornado
                {
                    AddVehicleComponent(car,1135);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }

                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                }
            }
            case 4:// Large
            {
                if(
                modelid == 401 ||//bravura
                modelid == 518 ||//buccaneer
                modelid == 527 ||//cadrona
                modelid == 542 ||//clover
                modelid == 589 ||//club
                modelid == 400 ||//landstalker
                modelid == 517 ||//majestic
                modelid == 603 ||//phoenix
                modelid == 426 ||//premier
                modelid == 547 ||//primo
                modelid == 405 ||//sentinel
                modelid == 580 ||//stafford
                modelid == 550 ||//sunrise
                modelid == 549 ||//tampa
                modelid == 477)//zr-350
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 527) // cadrona
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 542) // clover
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589) // club
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 400) // landstalker
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 580) // stafford
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // zr-350
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1020);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                }
                else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
            }
            case 5: // Medium
            {
                    if(
                modelid == 527 ||//cadrona
                modelid == 542 ||//clover
                modelid == 400 ||//landstalker
                modelid == 426 ||//premier
                modelid == 436 ||//previon
                modelid == 547 ||//primo
                modelid == 405 ||//sentinel
                modelid == 477)//zr-350
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 527) // cadrona
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 542) // clover
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 400) // landstalker
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426) // premier
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // zr350
                    {
                    AddVehicleComponent(car,1021);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
            }
            case 6: // Small
            {
                    if(
                modelid == 436)//previon
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1022);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
            }
            case 7: // Twin
            {
                    if(
                modelid == 518 ||//buccaneer
                modelid == 415 ||//cheetah
                modelid == 542 ||//clover
                modelid == 546 ||//intruder
                modelid == 400 ||//landstalker
                modelid == 517 ||//majestic
                modelid == 603 ||//phoenix
                modelid == 426 ||//premier
                modelid == 436 ||//previon
                modelid == 547 ||//primo
                modelid == 405 ||//sentinel
                modelid == 550 ||//sunrise
                modelid == 549 ||//tampa
                modelid == 477)//zr-350
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 415) // cheetah
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 542) // clover
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 400) // landstalker
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426) // premier
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405 ) // sentinel
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // zr-350
                    {
                    AddVehicleComponent(car,1019);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
            }
            case 8: // Upswept
            {
                    if(
                modelid == 401 ||//bravura
                modelid == 518 ||//buccaneer
                modelid == 415 ||//cheetah
                modelid == 542 ||//clover
                modelid == 546 ||//intruder
                modelid == 400 ||//landstalker
                modelid == 517 ||//majestic
                modelid == 603 ||//phoenix
                modelid == 426 ||//premier
                modelid == 415 ||//cheetah
                modelid == 547 ||//primo
                modelid == 405 ||//sentinel
                modelid == 550 ||//sunrise
                modelid == 549 ||//tampa
                modelid == 477)//zr-350
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 415) // cheetah
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 527) // cadrona
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 542) // clover
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589) // club
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 400) // landstalker
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 580) // stafford
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1018);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // zr-350
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1018);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
                    }
            }
            case 9: // _
            {
            Dialog_Show(playerid, DIALOG_TYPE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust\n \nBack", "Apply", "Close");
            }
            case 10: // Back
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_FBUMPS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 

        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1171);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1153);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jester
                {
                    AddVehicleComponent(car,1160);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1155);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1169);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558) // Uranus
                {
                    AddVehicleComponent(car,1166);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 1:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {

                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1172);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1152);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jetser
                {
                    AddVehicleComponent(car,1173);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1157);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1170);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558)  // Uranus
                {
                    AddVehicleComponent(car,1165);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 2:
            {
                if(modelid == 575 ||
            modelid == 534 ||
            modelid == 567 ||
            modelid == 536 ||
            modelid == 576 ||
            modelid == 535)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 575) // Brodway
                {
                    AddVehicleComponent(car,1174);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 534)// Remington
                {
                    AddVehicleComponent(car,1179);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 567)// Savanna
                {
                    AddVehicleComponent(car,1189);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1182);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1115);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 576) // Tornado
                {
                    AddVehicleComponent(car,1191);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 3:
            {
                if(modelid == 575 ||
            modelid == 534 ||
            modelid == 567 ||
            modelid == 535 ||
            modelid == 536 ||
            modelid == 576 ||
            modelid == 576)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 575) // Brodway
                {
                    AddVehicleComponent(car,1175);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 534)// Remington
                {
                    AddVehicleComponent(car,1185);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 567)// Savanna
                {
                    AddVehicleComponent(car,1188);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1181);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }

                else if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1116);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 576) // Tornado
                {
                    AddVehicleComponent(car,1190);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }

                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 4:
            {
            Dialog_Show(playerid, DIALOG_TYPE_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper\n \nBack", "Apply", "Close");
            }
            case 5:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_RBUMPS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {

                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1149);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1150);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jester
                {
                    AddVehicleComponent(car,1159);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1154);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1141);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558) // Uranus
                {
                    AddVehicleComponent(car,1168);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 1:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {


                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1148);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] YComponent successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1151);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jetser
                {
                    AddVehicleComponent(car,1161);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1156);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1140);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558)  // Uranus
                {
                    AddVehicleComponent(car,1167);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 2:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 560)
            {


                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1148);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1151);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 559) // Jetser
                {
                    AddVehicleComponent(car,1161);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1156);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1140);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 558)  // Uranus
                {
                    AddVehicleComponent(car,1167);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                }
                    else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 3:
            {
                if(modelid == 575 ||
            modelid == 534 ||
            modelid == 567 ||
            modelid == 536 ||
            modelid == 576 ||
            modelid == 535)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 575) // Brodway
                {
                    AddVehicleComponent(car,1177);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 534)// Remington
                {
                    AddVehicleComponent(car,1178);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 567)// Savanna
                {
                    AddVehicleComponent(car,1186);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1183);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }

                    else if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1110);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }

                    else if(modelid == 576) // Tornado
                {
                    AddVehicleComponent(car,1193);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }

                }
                    else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
                }
            }
            case 4:
            {
                Dialog_Show(playerid, DIALOG_TYPE_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper\n \nBack", "Apply", "Close");
            }
            case 5:
            {
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_ROOFS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {

                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1038);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1054);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 559) // Jester
                {
                    AddVehicleComponent(car,1067);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1055);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1032);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 558) // Uranus
                {
                    AddVehicleComponent(car,1088);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                }
                    else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
            }
            case 1:
            {
                if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {


                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1035);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1053);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 559) // Jetser
                {
                    AddVehicleComponent(car,1068);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1061);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1033);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 558)  // Uranus
                {
                    AddVehicleComponent(car,1091);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                }
                    else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
            }
            case 2:
            {
                if(modelid == 567 ||
            modelid == 536)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 567) // Savanna
                {
                    AddVehicleComponent(car,1130);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1128);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                }
                    else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
            }
            case 3:
            {
                if(modelid == 567 ||
            modelid == 536)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 567) // Savanna
                {
                    AddVehicleComponent(car,1131);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                    else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1103);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
                }
                    else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
                }
            }
            case 4:
            {
                if(
                modelid == 401 ||
                modelid == 518 ||
                modelid == 589 ||
                modelid == 492 ||
                modelid == 546 ||
                modelid == 603 ||
                modelid == 426 ||
                modelid == 436 ||
                modelid == 580 ||
                modelid == 550||
                modelid == 477)
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 492)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 580)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477)
                    {
                    AddVehicleComponent(car,1006);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Roof Scoop\n \nBack", "Apply", "Close");
                    }
            }
            case 5:
            {
                Dialog_Show(playerid, DIALOG_TYPE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop\n \nBack", "Apply", "Close");
            }
            case 6:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_SPOILERS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {

                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1147);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1049);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jester
                {
                    AddVehicleComponent(car,1162);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1158);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1138);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558) // Uranus
                {
                    AddVehicleComponent(car,1164);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
            }
            case 1:
            {
            if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {


                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1146);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1150);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jetser
                {
                    AddVehicleComponent(car,1158);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1060);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1139);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558)  // Uranus
                {
                    AddVehicleComponent(car,1163);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                }
            }
            case 2:// Win
            {
            if(
                modelid == 401 ||//bravura
                modelid == 518 ||//buccaneer
                modelid == 527 ||//cadrona
                modelid == 415 ||//cheetah
                modelid == 546 ||//intruder
                modelid == 603 ||//phoenix
                modelid == 426 ||//premier
                modelid == 436 ||//previon
                modelid == 405 ||//sentinel
                modelid == 477 ||//stallion
                modelid == 580 ||//stafford
                modelid == 550 ||//sunrise
                modelid == 549)//tampa
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 527) // cadrona
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 415) // cheetah
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426) // premier
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // stallion
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 580) // stafford
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1001);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 3: // Fury
            {
                    if(
                modelid == 518 ||//buccaneer
                modelid == 415 ||//cheetah
                modelid == 546 ||//intruder
                modelid == 517 ||//majestic
                modelid == 603 ||//phoenix
                modelid == 405 ||//sentinel
                modelid == 477 ||//stallion
                modelid == 580 ||//stafford
                modelid == 550 ||//sunrise
                modelid == 549)//tampa
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 415) // cheetah
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // stallion
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 580) // stafford
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1023);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 4: // Alpha
            {
                    if(
                modelid == 518 ||//buccaneer
                modelid == 415 ||//cheetah
                modelid == 401 ||//bravura
                modelid == 517 ||//majestic
                modelid == 426 ||//premier
                modelid == 436 ||//previon
                modelid == 477 ||//stallion
                modelid == 547 ||//primo
                modelid == 550 ||//sunrise
                modelid == 549)//tampa
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 415) // cheetah
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426) // premier
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477) // stallion
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1003);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 5: // Pro
            {
                    if(
                modelid == 589 ||//club
                modelid == 492 ||//greenwood
                modelid == 547 ||//primo
                modelid == 405)//sentinel
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 518) // club
                    {
                    AddVehicleComponent(car,1000);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 492) // greenwood
                    {
                    AddVehicleComponent(car,1000);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1000);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1000);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 6: // Champ
            {
                    if(
                modelid == 527 ||//cadrona
                modelid == 542 ||//clover
                modelid == 405)//sentinel
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 527) // cadrona
                    {
                    AddVehicleComponent(car,1014);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 542) // clover
                    {
                    AddVehicleComponent(car,1014);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 405) // sentinel
                    {
                    AddVehicleComponent(car,1014);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 7: // Race
            {
            if(
                modelid == 527 ||//cadrona
                modelid == 542)//clover
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 527) // cadrona
                    {
                    AddVehicleComponent(car,1014);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 542) // clover
                    {
                    AddVehicleComponent(car,1014);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 8: // Drag
            {
            if(
                modelid == 546 ||//intruder
                modelid == 517)//majestic
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1002);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1002);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
                    }
            }
            case 9:
            {
            Dialog_Show(playerid, DIALOG_TYPE_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n \nBack", "Apply", "Close");
            }
            case 10:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_SIDESKIRTS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {

                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1036);
                    AddVehicleComponent(car,1040);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1047);
                    AddVehicleComponent(car,1051);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jester
                {
                    AddVehicleComponent(car,1069);
                    AddVehicleComponent(car,1071);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] YComponent successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1056);
                    AddVehicleComponent(car,1062);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1026);
                    AddVehicleComponent(car,1027);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558) // Uranus
                {
                    AddVehicleComponent(car,1090);
                    AddVehicleComponent(car,1094);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 1:
            {
            if(modelid == 562 ||
            modelid == 565 ||
            modelid == 559 ||
            modelid == 561 ||
            modelid == 558 ||
            modelid == 560)
            {


                new car = GetPlayerVehicleID(playerid);
                if(modelid == 562) // Elegy
                {
                    AddVehicleComponent(car,1039);
                    AddVehicleComponent(car,1041);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 565) // Flash
                {
                    AddVehicleComponent(car,1048);
                    AddVehicleComponent(car,1052);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 559) // Jetser
                {
                    AddVehicleComponent(car,1070);
                    AddVehicleComponent(car,1072);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 561) // Stratum
                {
                    AddVehicleComponent(car,1057);
                    AddVehicleComponent(car,1063);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 560) // Sultan
                {
                    AddVehicleComponent(car,1031);
                    AddVehicleComponent(car,1030);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 558)  // Uranus
                {
                    AddVehicleComponent(car,1093);
                    AddVehicleComponent(car,1095);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 2:
            {
            if(modelid == 575 ||
                modelid == 536 ||
                modelid == 576 ||
                modelid == 567)
                {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 575) // Brodway
                {
                    AddVehicleComponent(car,1042);
                    AddVehicleComponent(car,1099);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 567) // Savanna
                {
                    AddVehicleComponent(car,1102);
                    AddVehicleComponent(car,1133);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 576) // Tornado
                {
                    AddVehicleComponent(car,1134);
                    AddVehicleComponent(car,1137);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                else if(modelid == 536) // Blade
                {
                    AddVehicleComponent(car,1108);
                    AddVehicleComponent(car,1107);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 3:
            {
            if(modelid == 534 ||
            modelid == 534)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 534) // Remington
                {
                    AddVehicleComponent(car,1122);
                    AddVehicleComponent(car,1101);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car.");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 4:
            {
            if(modelid == 534 ||
            modelid == 534)
            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 534) // Remington
                {
                    AddVehicleComponent(car,1106);
                    AddVehicleComponent(car,1124);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 5:
            {
            if(modelid == 535)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1118);
                    AddVehicleComponent(car,1120);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 6:
            {
            if(modelid == 535)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1119);
                    AddVehicleComponent(car,1121);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
                }
            }
            case 7:
            {
            if(
                modelid == 401 ||
                modelid == 518 ||
                modelid == 527 ||
                modelid == 415 ||
                modelid == 589 ||
                modelid == 546 ||
                modelid == 517 ||
                modelid == 603 ||
                modelid == 436 ||
                modelid == 439 ||
                modelid == 580 ||
                modelid == 549 ||
                modelid == 477)
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 527)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 415)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 439)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 580)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 477)
                    {
                    AddVehicleComponent(car,1007);
                    AddVehicleComponent(car,1017);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Side Skirt\n \nBack", "Apply", "Close");
                    }
            }
            case 8:
            {
            Dialog_Show(playerid, DIALOG_TYPE_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt\n \nBack", "Apply", "Close");
            }
            case 9:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_BULLBARS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(modelid == 534)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 534) // Remington
                {
                    AddVehicleComponent(car,1100);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
            }
            case 1: 
            {
            if(modelid == 534)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 534) // Remington
                {
                    AddVehicleComponent(car,1123);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
            }
            case 2:
            {
            if(modelid == 534)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 534) // Remington
                {
                    AddVehicleComponent(car,1125);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] You cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
            }
            case 3:
            {
            if(modelid == 535)

            {
                new car = GetPlayerVehicleID(playerid);
                if(modelid == 535) // Slamvan
                {
                    AddVehicleComponent(car,1117);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                    Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
                }
                else
                {
                SendClientMessage(playerid,COLOR_YELLOW,"[WARNING] ou cannot install this component to your car. ");
                Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
                }
            }
            case 4:
            {
            Dialog_Show(playerid, DIALOG_TYPE_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar\n \nBack", "Apply", "Close");
            }
            case 5:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_WHEELS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1025);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Offroad Wheels ");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 1:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1074);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Mega Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 2:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1076);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Wires Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 3:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1078);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Twist Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 4:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1081);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Grove Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 5:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1082);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Import Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 6:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1085);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Atomic Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 7:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1096);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Ahab Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 8:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1097);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Virtual Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 9:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1098);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Access Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 10:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1084);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Trance Wheels ");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 11:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1073);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Shadow Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 12:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1075);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Rimshine Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 13:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1077);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Classic Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 14:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1079);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Cutter Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 15:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1080);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Switch Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 16:
            {
                if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1083);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You have succesfully added Dollar Wheels");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
                else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            }
            case 17:
            {
                Dialog_Show(playerid, DIALOG_TYPE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar\n \nBack", "Apply", "Close");
            }
            case 18:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }
}
Dialog:DIALOG_TYPE_CSTEREO(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1086);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added. ");
                Dialog_Show(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
            }
            }
            case 1:
            {
            Dialog_Show(playerid, DIALOG_TYPE_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost\n \nBack", "Apply", "Close");
            }
            case 2:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_HYDRAULICS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1087);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added. ");
                Dialog_Show(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
            }
            }
            case 1:
            {
            Dialog_Show(playerid, DIALOG_TYPE_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics\n \nBack", "Apply", "Close");
            }
            case 2:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_NITRO(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        switch(listitem)// Checking which list item was selected
        {
            case 0:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1008);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added. ");
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
            }
            case 1:
            {
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1009);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
            }
            case 2:
            if(GetPlayerMoney(playerid) >= 0)
            {
                new car = GetPlayerVehicleID(playerid);
                AddVehicleComponent(car,1010);
                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added.");
                Dialog_Show(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
            }
            else
            {
                SendClientMessage(playerid,COLOR_RED,"Not enough money!");
                Dialog_Show(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
            }
            case 3:
            {
            Dialog_Show(playerid, DIALOG_TYPE_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous\n \nBack", "Apply", "Close");
            }
            case 4:
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_HOODS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:// fury
            {
                if(
                modelid == 401 ||
                modelid == 518 ||
                modelid == 589 ||
                modelid == 492 ||
                modelid == 426 ||
                modelid == 550)
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1005);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1005);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589) // club
                    {
                    AddVehicleComponent(car,1005);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 492) // greenwood
                    {
                    AddVehicleComponent(car,1005);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426) // premier
                    {
                    AddVehicleComponent(car,1005);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1005);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                }
                else
                {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                }
            }
            case 1: // Champ
            {
            if(
                modelid == 401 ||
                modelid == 492 ||
                modelid == 546 ||
                modelid == 426 ||
                modelid == 550)
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1004);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1004);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 492) // greenwood
                    {
                    AddVehicleComponent(car,1004);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 426) // premier
                    {
                    AddVehicleComponent(car,1004);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1004);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                }
                else
                {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                }
            }
            case 2: // Race
            {
            if(
                modelid == 549)
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1011);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                }
                else
                {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                }
            }
            case 3: // Worx
            {
            if(
                modelid == 549)
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1012);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                    }
                }
                else
                {
                SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
                }
            }
            case 4:
            {
            Dialog_Show(playerid, DIALOG_TYPE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n \nBack", "Apply", "Close");
            }
            case 5: // Back
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}

Dialog:DIALOG_TYPE_VENTS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:// Oval
            {
                if(
                modelid == 401 ||//bravura
                modelid == 518 ||//buccaneer
                modelid == 546 ||//intruder
                modelid == 517 ||//majestic
                modelid == 603 ||//phoenix
                modelid == 547 ||//primo
                modelid == 439 ||//stallion
                modelid == 550 ||//sunrise
                modelid == 549)//tampa
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 547) // primo
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 439) // stallion
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1142);
                    AddVehicleComponent(car,1143);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                }
                else
                    {
                        SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                        Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
            }
            case 1: // Square
            {
            if(
                modelid == 401 ||//bravura
                modelid == 518 ||//buccaneer
                modelid == 589 ||//club
                modelid == 546 ||//intruder
                modelid == 517 ||//majestic
                modelid == 603 ||//phoenix
                modelid == 439 ||//stallion
                modelid == 550 ||//sunrise
                modelid == 549)//tampa
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589) // club
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 546) // intruder
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 517) // majestic
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 439) // stallion
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 550) // sunrise
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 549) // tampa
                    {
                    AddVehicleComponent(car,1144);
                    AddVehicleComponent(car,1145);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                }
                    else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
            }
            case 2: // _
            {
            Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
            }
            case 3: // Back
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }

    return 1;
}
Dialog:DIALOG_TYPE_LIGHTS(playerid, response, listitem, inputtext[])
{
    if(!response)
    {
        SetCameraBehindPlayer(playerid);
    }
    if(response)
    {
        new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)); 
        switch(listitem)// Checking which list item was selected
        {
            case 0:// round
            {
                if(
                modelid == 401 ||//bravura
                modelid == 518 ||//buccaneer
                modelid == 589 ||//club
                modelid == 400 ||//landstalker
                modelid == 436 ||//previon
                modelid == 439)//stallion
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 401) // bravura
                    {
                    AddVehicleComponent(car,1013);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 518) // buccaneer
                    {
                    AddVehicleComponent(car,1013);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 589) // club
                    {
                    AddVehicleComponent(car,1013);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 400) // landstalker
                    {
                    AddVehicleComponent(car,1013);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 436) // previon
                    {
                    AddVehicleComponent(car,1013);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 439) // stallion
                    {
                    AddVehicleComponent(car,1013);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
                }
                else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
            }
            case 1: // Square
            {
            if(
                modelid == 589 ||//club
                modelid == 603 ||//phoenix
                modelid == 400)//landstalker
                {
                    new car = GetPlayerVehicleID(playerid);
                    if(modelid == 589) // club
                    {
                    AddVehicleComponent(car,1024);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 603) // phoenix
                    {
                    AddVehicleComponent(car,1024);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                    if(modelid == 400) // landstalker
                    {
                    AddVehicleComponent(car,1024);
                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] Component successfully added");
                    Dialog_Show(playerid, DIALOG_TYPE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n \nBack", "Apply", "Close");
                    }
                }
                else
                    {
                    SendClientMessage(playerid,COLOR_WHITE,"[INFO] You cannot install this component on your car.");
                    Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
                    }
            }
            case 2: // _
            {
            Dialog_Show(playerid, DIALOG_TYPE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n \nBack", "Apply", "Close");
            }
            case 3: // Back
            {
            Dialog_Show(playerid, DIALOG_TYPE_MAIN, DIALOG_STYLE_LIST, "Car Tuning Menu", "Paint Jobs\nColors\nHoods\nVents\nLights\nExhausts\nFront Bumpers\nRear Bumpers\nRoofs\nSpoilers\nSide Skirts\nBullbars\nWheels\nCar Stereo\nHydraulics\nNitrous Oxide\nRepair Car", "Enter", "Close");
            }
        }
    }
    return 1;
}
