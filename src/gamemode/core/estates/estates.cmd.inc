#include "core\estates\biz\biz.cmd.pwn"
#include "core\estates\house\house.cmd.pwn"
#include "core\estates\garage\garage.cmd.pwn"
#include "core\estates\entrance\entrance.cmd.pwn"

CMD:activity(playerid, params[])
{
	new type[16];

	SendClientMessage(playerid, COLOR_NAVYBLUE, "_______ My Properties _______");

    foreach(new i : House)
    {
        if(HouseInfo[i][hExists] && IsHouseOwner(playerid, i))
        {
            if(HouseInfo[i][hType] == -1)
			{
			    type = "Other";
			}
			else
			{
			    strcpy(type, houseInteriors[HouseInfo[i][hType]][intClass]);
			}

	        if((gettime() - HouseInfo[i][hTimestamp]) > 2592000)
    	    {
        	    SendClientMessageEx(playerid, COLOR_GREY2, "Your %s house in %s is currently marked as {FF6347}Inactive{C8C8C8}.", type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]));
			}
			else
			{
		    	SendClientMessageEx(playerid, COLOR_GREY2, "Your %s house in %s is currently marked as {00AA00}Active{C8C8C8}.", type, GetZoneName(HouseInfo[i][hPosX], HouseInfo[i][hPosY], HouseInfo[i][hPosZ]));
			}
		}
	}

 	foreach(new i : Garage)
    {
        if(GarageInfo[i][gExists] && IsGarageOwner(playerid, i))
        {
	        if((gettime() - GarageInfo[i][gTimestamp]) > 2592000)
    	    {
        	    SendClientMessageEx(playerid, COLOR_GREY2, "Your %s garage in %s is currently marked as {FF6347}Inactive{C8C8C8}.", garageInteriors[GarageInfo[i][gType]][intName], GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]));
			}
			else
			{
		    	SendClientMessageEx(playerid, COLOR_GREY2, "Your %s garage in %s is currently marked as {00AA00}Active{C8C8C8}.", garageInteriors[GarageInfo[i][gType]][intName], GetZoneName(GarageInfo[i][gPosX], GarageInfo[i][gPosY], GarageInfo[i][gPosZ]));
			}
		}
	}

 	foreach(new i : Business)
    {
        if(BusinessInfo[i][bExists] && IsBusinessOwner(playerid, i))
        {
	        if((gettime() - BusinessInfo[i][bTimestamp]) > 2592000)
    	    {
        	    SendClientMessageEx(playerid, COLOR_GREY2, "Your %s business in %s is currently marked as {FF6347}Inactive{C8C8C8}.", bizInteriors[BusinessInfo[i][bType]][intType], GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]));
			}
			else
			{
		    	SendClientMessageEx(playerid, COLOR_GREY2, "Your %s business in %s is currently marked as {00AA00}Active{C8C8C8}.", bizInteriors[BusinessInfo[i][bType]][intType], GetZoneName(BusinessInfo[i][bPosX], BusinessInfo[i][bPosY], BusinessInfo[i][bPosZ]));
			}
		}
	}

	SendClientMessage(playerid, COLOR_YELLOW, "* Your properties become inactive if you don't enter them for 30+ days.");
	return 1;
}
