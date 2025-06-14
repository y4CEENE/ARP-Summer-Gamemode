#!/usr/bin/env python

import socket


timeout = 1.0
socket_cls = socket.socket
address = "51.159.92.128"
port = 7777

try:
    socket = socket_cls(socket.AF_INET, socket.SOCK_DGRAM)
    socket.settimeout(timeout)
    socket.sendto(b"SAMP\x7f\x00\x00\x01\x61\x1Ei", (address, port))
    response = socket.recv(4096)
    socket.close()
    print(int("".join("{:02x}".format(ord(c)) for c in reversed(response[12:14])),16))
except:
    print("-1")
    



