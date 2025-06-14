
#if defined _zlib_included
	#endinput
#endif	
#define _zlib_included

stock SetServerName(name[])
{
  new tmp[256];
  format(tmp, sizeof tmp, "hostname %s", name);
  SendRconCommand(tmp);
}

stock SetMaxPlayers(value)
{//Max PLayers is a constant value!!!
  new tmp[256];
  format(tmp, sizeof tmp, "maxplayers %d", value);
  SendRconCommand(tmp);
}

stock SetLanguage(name[])
{
  new tmp[256];
  format(tmp, sizeof tmp, "language %s", name);
  SendRconCommand(tmp);
}

stock SetWebsite(url[])
{
  new tmp[256];
  format(tmp, sizeof tmp, "weburl %s", url);
  SendRconCommand(tmp);
}

stock SetMapName(name[])
{
  new tmp[256];
  format(tmp, sizeof tmp, "mapname %s", name);
  SendRconCommand(tmp);
}

