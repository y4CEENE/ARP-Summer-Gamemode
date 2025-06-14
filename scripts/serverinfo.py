#!/usr/bin/env python

import socket


timeout = 10.0
socket_cls = socket.socket

address = "127.0.0.1"
port = 7777

with open('server.cfg') as f:
    lines = f.readlines()
    for line in lines:
        if line.startswith("bind ") :
            address = line[5:-1]  
        elif line.startswith("port ") :
            port = int(line[5:])

socket = socket_cls(socket.AF_INET, socket.SOCK_DGRAM)
socket.settimeout(timeout)
socket.sendto(b"SAMP\x7f\x00\x00\x01\x61\x1Ei", (address, port))
response = socket.recv(4096)
socket.close()

print("bind=" + address) 
print("port=" + str(port))
print("password=" + str(int("".join("{:02x}".format(ord(response[11]))))))
print("online_players=" + str(int("".join("{:02x}".format(ord(c)) for c in reversed(response[12:14])),16)))
print("max_players=" + str(int("".join("{:02x}".format(ord(c)) for c in reversed(response[14:16])),16)))

hostnameoffset=16
hostnamelen=int("".join("{:02x}".format(ord(c)) for c in reversed(response[16:20])),16)
gamemodeoffset=hostnameoffset+4+hostnamelen
gamemodelen=int("".join("{:02x}".format(ord(c)) for c in reversed(response[gamemodeoffset:gamemodeoffset+4])),16)
languageoffset=gamemodeoffset+4+gamemodelen
languagelen=int("".join("{:02x}".format(ord(c)) for c in reversed(response[languageoffset:languageoffset+4])),16)

print("hostname="+response[hostnameoffset+4:hostnameoffset+4+hostnamelen])
print("gamemode="+response[gamemodeoffset+4:gamemodeoffset+4+gamemodelen])
print("language="+response[languageoffset+4:languageoffset+4+languagelen])

