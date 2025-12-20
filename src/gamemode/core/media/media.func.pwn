
stock ShowCreateRadioStation(playerid)
{
    Dialog_Show(playerid, DIALOG_ADDSTATION, DIALOG_STYLE_INPUT, "Radio Station Manager", "Enter the link of the station you'd like to add", "Add", "Cancel");
}

ShowMP3Player(playerid)
{
    Dialog_Show(playerid, MP3PLAYER, DIALOG_STYLE_LIST, "MP3 player", "Custom URL\nUploaded Music\nRadio Stations\nStop Music\nVIP Music", "Select", "Cancel");
}

ShowMP3RadioStations(playerid)
{
    Dialog_Show(playerid, MP3RADIO, DIALOG_STYLE_LIST, "Radio Stations", "Browse Genres\nSearch by Name", "Select", "Back");
}

ShowMP3RadioStationsGenres(playerid)
{

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT DISTINCT genre FROM radiostations ORDER BY genre");
    mysql_tquery(connectionID, queryBuffer, "Radio_ListGenres", "i", playerid);
}

/*ShowMP3RadioStationsSubGenres(playerid)
{
    for(new i = 0; i < sizeof(radioGenreList); i ++)
    {
        if(!strcmp(radioGenreList[i][rGenre], PlayerData[playerid][pGenre]))
        {
            format(string, sizeof(string), "%s\n%s", string, radioGenreList[i][rSubgenre]);
        }
    }

    Dialog_Show(playerid, MP3RADIOSUBGENRES, DIALOG_STYLE_LIST, "Choose a subgenre to browse stations in.", string, "Select", "Back");
}*/

ShowMP3RadioStationSearchResult(playerid)
{
	new page = (PlayerData[playerid][pPage] - 1) * MAX_LISTED_STATIONS;
	if(page < 0)
	{
		page = 0;
	}
    if(PlayerData[playerid][pSearch])
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name FROM radiostations WHERE name LIKE '%%%e%%' OR subgenre LIKE '%%%e%%' ORDER BY name LIMIT %i, %i", PlayerData[playerid][pGenre], PlayerData[playerid][pGenre], page, MAX_LISTED_STATIONS);
        mysql_tquery(connectionID, queryBuffer, "Radio_ListStations", "i", playerid);
    }
    else
    {
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name FROM radiostations WHERE genre = '%e' ORDER BY name LIMIT %i, %i", PlayerData[playerid][pGenre], page, MAX_LISTED_STATIONS);
        mysql_tquery(connectionID, queryBuffer, "Radio_ListStations", "i", playerid);
    }
}

ShowMP3RadioStationSearch(playerid)
{
    Dialog_Show(playerid, MP3RADIOSEARCH, DIALOG_STYLE_INPUT, "Search by Name", "Enter the full or partial name of the radio station:", "Submit", "Back");
}

/*ShowMP3RadioStationAPISearch(playerid)
{
    Dialog_Show(playerid, MP3APISEARCH, DIALOG_STYLE_INPUT, "Search by Name", "Enter the full or partial name of the radio station:", "Submit", "Back");
}*/

Dialog:MP3PLAYER(playerid, response, listitem, inputtext[])
{
	if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                Dialog_Show(playerid, MP3URL, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to play:", "Submit", "Back");
            }
            case 1:
            {
          		Dialog_Show(playerid, MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
            }
            case 2:
            {
				if(!connectionID)
				{
				    return SendClientMessage(playerid, COLOR_GREY, "The radio station database is currently unavailable.");
				}

				ShowMP3RadioStations(playerid);
			}
		     case 3:
	       	  {
				switch(PlayerData[playerid][pMusicType])
				{
					case MUSIC_MP3PLAYER:
					{
					   	SetMusicStream(MUSIC_MP3PLAYER, playerid, "");
            			ShowActionBubble(playerid, "* %s turns off their MP3 player.", GetRPName(playerid));
					}
					case MUSIC_BOOMBOX:
					{
					    SetMusicStream(MUSIC_BOOMBOX, playerid, "");
						ShowActionBubble(playerid, "* %s turns off their boombox.", GetRPName(playerid));
					}
					case MUSIC_VEHICLE:
					{
					    if(IsPlayerInAnyVehicle(playerid))
					    {
						    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), "");
							ShowActionBubble(playerid, "* %s turns off the radio in the vehicle.", GetRPName(playerid));
						}
					}
				}
			}
			case 4:
			{
				 if(PlayerData[playerid][pDonator] < 1)
				 {
					 return SendClientMessage(playerid, COLOR_GREY, "You must be a VIP to use this option");
				 }
				 Dialog_Show(playerid, DIALOG_VIPMUSIC, DIALOG_STYLE_INPUT, "VIP Uploaded Music", "Please enter the name of the .mp3 file to play:", "Submit", "Back");
			}
  		}
	}
	return 1;
}
Dialog:MP3MUSIC(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new url[128];

        if(isnull(inputtext) || strfind(inputtext, ".mp3", true) == -1)
        {
            return Dialog_Show(playerid, MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
		}

		for(new i = 0, l = strlen(inputtext); i < l; i ++)
		{
		    switch(inputtext[i])
		    {
		        case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '\'', ' ':
		        {
					continue;
				}
				default:
				{
				    SendClientMessage(playerid, COLOR_GREY, "The name of the .mp3 contains invalid characters, please try again.");
				    return Dialog_Show(playerid, MP3MUSIC, DIALOG_STYLE_INPUT, "Uploaded Music", "Please enter the name of the .mp3 file to play:\n(Use /music for a list of all music uploaded to the server.)", "Submit", "Back");
				}
		    }
		}

		format(url, sizeof(url), "http://%s/%s", GetServerMusicUrl(), inputtext);

		switch(PlayerData[playerid][pMusicType])
		{
            case MUSIC_MP3PLAYER:
            {
                SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
		  		ShowActionBubble(playerid, "* %s changes the song on their MP3 player.", GetRPName(playerid));
			}
			case MUSIC_BOOMBOX:
			{
			    SetMusicStream(MUSIC_BOOMBOX, playerid, url);
				ShowActionBubble(playerid, "* %s changes the song on their boombox.", GetRPName(playerid));
			}
			case MUSIC_VEHICLE:
			{
			    if(IsPlayerInAnyVehicle(playerid))
			    {
				    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
					ShowActionBubble(playerid, "* %s changes the song on the radio.", GetRPName(playerid));
				}
			}
		}

		SendClientMessageEx(playerid, COLOR_AQUA, "You have started the playback of {00AA00}%s{33CCFF}.", inputtext);
    }
    else
    {
        ShowMP3Player(playerid);
	}
	return 1;
}
Dialog:DIALOG_VIPMUSIC(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new url[128];

        if(isnull(inputtext))
        {
            return Dialog_Show(playerid, DIALOG_VIPMUSIC, DIALOG_STYLE_INPUT, "VIP Uploaded Music", "Please enter the name of the .mp3 file to play:", "Submit", "Back");
		}

		for(new i = 0, l = strlen(inputtext); i < l; i ++)
		{
		    switch(inputtext[i])
		    {
		        case 'A'..'Z', 'a'..'z', '0'..'9', '_', '.', '\'', ' ':
		        {
					continue;
				}
				default:
				{
				    SendClientMessage(playerid, COLOR_GREY, "The name of the .mp3 contains invalid characters, please try again.");
				    return Dialog_Show(playerid, DIALOG_VIPMUSIC, DIALOG_STYLE_INPUT, "VIP Uploaded Music", "Please enter the name of the .mp3 file to play:", "Submit", "Back");
				}
		    }
		}

		format(url, sizeof(url), "http://%s/%d/%s", GetVipMusicUrl(), PlayerData[playerid][pID], inputtext);
		switch(PlayerData[playerid][pMusicType])
		{
            case MUSIC_MP3PLAYER:
            {
                SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
		  		ShowActionBubble(playerid, "* %s changes the song on their MP3 player.", GetRPName(playerid));
			}
			case MUSIC_BOOMBOX:
			{
			    SetMusicStream(MUSIC_BOOMBOX, playerid, url);
				ShowActionBubble(playerid, "* %s changes the song on their boombox.", GetRPName(playerid));
			}
			case MUSIC_VEHICLE:
			{
			    if(IsPlayerInAnyVehicle(playerid))
			    {
				    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
					ShowActionBubble(playerid, "* %s changes the song on the radio.", GetRPName(playerid));
				}
			}
		}

		SendClientMessageEx(playerid, COLOR_AQUA, "You have started the playback of {00AA00}%s{33CCFF}.", inputtext);
    }
    else
    {
        ShowMP3Player(playerid);
	}
	return 1;
}
Dialog:MP3URL(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(isnull(inputtext))
        {
            return Dialog_Show(playerid, MP3URL, DIALOG_STYLE_INPUT, "Custom URL", "Please enter the URL of the stream you want to play:", "Submit", "Back");
  		}
		//if(!IsValidYoutubeUrl(inputtext) && strfind(inputtext, ".mp3", true) == -1)
        if(strfind(inputtext, ".mp3", true) == -1)
		{
		    return Dialog_Show(playerid, MP3URL, DIALOG_STYLE_INPUT, "Custom URL", ".MP3 Links only! Please enter another URL", "Submit", "Back");
		}

  		switch(PlayerData[playerid][pMusicType])
		{
            case MUSIC_MP3PLAYER:
            {
                SetMusicStream(MUSIC_MP3PLAYER, playerid, inputtext);
		  		ShowActionBubble(playerid, "* %s changes the song on their MP3 player.", GetRPName(playerid));
			}
			case MUSIC_BOOMBOX:
			{
			    SetMusicStream(MUSIC_BOOMBOX, playerid, inputtext);
				ShowActionBubble(playerid, "* %s changes the song on their boombox.", GetRPName(playerid));
			}
			case MUSIC_VEHICLE:
			{
			    if(IsPlayerInAnyVehicle(playerid))
			    {
				    SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), inputtext);
					ShowActionBubble(playerid, "* %s changes the song on the radio.", GetRPName(playerid));
				}
			}
		}
    }
    else
    {
        ShowMP3Player(playerid);
	}
	return 1;
}
Dialog:MP3RADIO(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                ShowMP3RadioStationsGenres(playerid);
            }
            case 1:
            {
                ShowMP3RadioStationSearch(playerid);
            }
            /*case 2:
            {
                ShowMP3RadioStationAPISearch(playerid);
            }*/
        }
    }
    else
    {
        ShowMP3Player(playerid);
	}
	return 1;
}
Dialog:MP3RADIOGENRES(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        strcpy(PlayerData[playerid][pGenre], inputtext, 32);
        PlayerData[playerid][pPage] = 1;
        ShowMP3RadioStationSearchResult(playerid);
        //ShowMP3RadioStationsSubGenres(playerid);
	}
	else
	{
        ShowMP3RadioStations(playerid);
    }
    return 1;
}
/*Dialog:MP3RADIOSUBGENRES(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        PlayerData[playerid][pPage] = 1;
 		PlayerData[playerid][pSearch] = 0;

        strcpy(PlayerData[playerid][pSubgenre], inputtext, 32);
        if(!PlayerData[playerid][pStationEdit])
        {
            ShowMP3RadioStationSearchResult(playerid);
		}
		else
		{
            
		    ShowDialogToPlayer(playerid, DIALOG_ADDSTATION);
		}
	}
	else
	{
        ShowMP3RadioStationsGenres(playerid);
	}
	return 1;
}*/
Dialog:MP3RADIORESULTS(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(!strcmp(inputtext, ">> Next page", true))
        {
            PlayerData[playerid][pPage]++;
            ShowMP3RadioStationSearchResult(playerid);
        }
        else if(!strcmp(inputtext, "<< Go back", true) && PlayerData[playerid][pPage] > 1)
        {
            PlayerData[playerid][pPage]--;
            ShowMP3RadioStationSearchResult(playerid);
        }
        else
        {
	        listitem = ((PlayerData[playerid][pPage] - 1) * MAX_LISTED_STATIONS) + listitem;
            if(listitem < 0)
            {
                return SendClientMessage(playerid, COLOR_GREY, "Cannot find radio signal.");
            }
			if(PlayerData[playerid][pSearch])
			{
			    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, url FROM radiostations WHERE name LIKE '%%%e%%' OR subgenre LIKE '%%%e%%' ORDER BY name LIMIT %i, 1", PlayerData[playerid][pGenre], PlayerData[playerid][pGenre], listitem);
				mysql_tquery(connectionID, queryBuffer, "Radio_PlayStation", "i", playerid);
			}
			else
			{
				mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT name, url FROM radiostations WHERE genre = '%e' ORDER BY name LIMIT %i, 1", PlayerData[playerid][pGenre], listitem);
	        	mysql_tquery(connectionID, queryBuffer, "Radio_PlayStation", "i", playerid);
			}
		}
	}
	else
	{
	    if(PlayerData[playerid][pSearch])
	    {
            ShowMP3RadioStationSearch(playerid);
	    }
	    else
	    {
            //ShowMP3RadioStationsSubGenres(playerid);
            ShowMP3RadioStationsGenres(playerid);
		}
	}
	return 1;
}
Dialog:MP3RADIOSEARCH(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext) < 3)
        {
            SendClientMessage(playerid, COLOR_GREY, "Your search query must contain 3 characters or more.");
            ShowMP3RadioStationSearch(playerid);
            return 1;
        }

        PlayerData[playerid][pPage] = 1;
        PlayerData[playerid][pSearch] = 1;

        strcpy(PlayerData[playerid][pGenre], inputtext, 32);
        ShowMP3RadioStationSearchResult(playerid);
    }
    else
    {
        ShowMP3RadioStations(playerid);
	}
	return 1;
}

forward Radio_ListGenres(playerid);
public Radio_ListGenres(playerid)
{
    new rows = cache_get_row_count(connectionID);

	if((!rows) && PlayerData[playerid][pSearch] && PlayerData[playerid][pPage] == 1)
	{
	    SendClientMessage(playerid, COLOR_GREY, "No results found.");
        ShowMP3RadioStationSearch(playerid);
	} else if(rows)
	{
        new string[4096];
        new genre[32] = "n/a";
    

        for(new i = 0; i < rows; i ++)
        {
            cache_get_field_content(i, "genre", genre);
            strcat(string, genre);
            strcat(string, "\n");
        }

        Dialog_Show(playerid, MP3RADIOGENRES, DIALOG_STYLE_LIST, "Choose a genre to browse stations in.", string, "Select", "Back");
	}

}
forward Radio_ListStations(playerid);
public Radio_ListStations(playerid)
{
	new rows = cache_get_row_count(connectionID);

	if((!rows) && PlayerData[playerid][pSearch] && PlayerData[playerid][pPage] == 1)
	{
	    SendClientMessage(playerid, COLOR_GREY, "No results found.");
        ShowMP3RadioStationSearch(playerid);
	}
	else if(rows)
	{
	    static string[MAX_LISTED_STATIONS * 64], name[128];

	    string[0] = 0;

	    for(new i = 0; i < rows; i ++)
	    {
	        cache_get_field_content(i, "name", name);
	        format(string, sizeof(string), "%s\n%s", string, name);
		}

		if(PlayerData[playerid][pPage] > 1)
		{
		    strcat(string, "\n{FF6347}<< Go back{FFFFFF}");
		}
		if(rows == MAX_LISTED_STATIONS)
		{
		    strcat(string, "\n{00AA00}>> Next page{FFFFFF}");
		}

		Dialog_Show(playerid, MP3RADIORESULTS, DIALOG_STYLE_LIST, "Results", string, "Play", "Back");
	}
}


forward Radio_PlayStation(playerid);
public Radio_PlayStation(playerid)
{
	if(cache_get_row_count(connectionID))
	{
	    new name[128], url[128];

	    cache_get_field_content(0, "name", name);
	    cache_get_field_content(0, "url", url);

	    switch(PlayerData[playerid][pMusicType])
	    {
	        case MUSIC_MP3PLAYER:
	        {
			    ShowActionBubble(playerid, "* %s changes the radio station on their MP3 player.", GetRPName(playerid));
	    		SendClientMessageEx(playerid, COLOR_AQUA, "You are now tuned in to {00AA00}%s{33CCFF}.", name);
				SetMusicStream(MUSIC_MP3PLAYER, playerid, url);
			}
			case MUSIC_BOOMBOX:
			{
			    ShowActionBubble(playerid, "* %s changes the radio station on their boombox.", GetRPName(playerid));
	    		SendClientMessageEx(playerid, COLOR_AQUA, "Your boombox is now tuned in to {00AA00}%s{33CCFF}.", name);
				SetMusicStream(MUSIC_BOOMBOX, playerid, url);
			}
			case MUSIC_VEHICLE:
			{
			    if(IsPlayerInAnyVehicle(playerid))
			    {
				    ShowActionBubble(playerid, "* %s changes the radio station in their vehicle.", GetRPName(playerid));
		    		SendClientMessageEx(playerid, COLOR_AQUA, "Your radio is now tuned in to {00AA00}%s{33CCFF}.", name);
					SetMusicStream(MUSIC_VEHICLE, GetPlayerVehicleID(playerid), url);
				}
			}
		}
	}
}
