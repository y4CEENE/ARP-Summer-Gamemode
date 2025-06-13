#!/usr/bin/env python

LOG_FILE="firewall.log"
FILE_TO_WATCH="/home/prod/arp_next/server_log.txt"
DELAY=1 # in seconds
DATE_TIME_LEN=19

import os
from datetime import datetime

#Write string to firewall log file
def log(str):
    f = open(LOG_FILE, "a")
    now = datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    f.write("[{}] {}\n".format(now, str))
    f.close()

#Check/ban ip
bannedIps = []
def isBannedIp(ip):
    return ip in bannedIps

def banIp(ip, reason):
    if os.system("/sbin/iptables -A INPUT -s " + ip + " -j DROP > /dev/null 2> /dev/null") == 0:
        bannedIps.append(ip)
        log(reason)
        return True
    log("Fail to ban '{}'".format(ip))
    return  False

# Decoding logs
def getLogDateTime(line):
    return line[1 : DATE_TIME_LEN + 1]

def isRequestConnectionCookie(line):
    return (line[DATE_TIME_LEN + 3 : DATE_TIME_LEN + 15] == "[connection]" and
            line.find("requests connection cookie.") != -1)

def getRequestConnectionCookieIp(line):
    return line[DATE_TIME_LEN + 16:line.find(':', DATE_TIME_LEN + 16)]

def isFireWallBanRequest(line):
    return (line[DATE_TIME_LEN + 3 : DATE_TIME_LEN + 26] == "REQUEST_FIREWALL_BAN_IP")

def getFireWallBanRequestIp(line):
    return line[DATE_TIME_LEN + 27:]

def isModifiedPacket(line):
    return line[DATE_TIME_LEN + 3 : DATE_TIME_LEN + 33] == "Packet was modified, sent by id:"

def getModifiedPacketPlayerIp(line):
    ipStartIdx = line.find(', ip: ', DATE_TIME_LEN + 33) + 6
    return line[ipStartIdx : line.find(':', ipStartIdx)]

# Check `server_log.txt` and ban ip using iptable
def checkLogs(filename, logFile):
    records = {}
    lastLines = os.popen("tail -n20 " + filename).read().split('\n')
    for line in lastLines:
        if len(line) == 0:
            continue

        if isFireWallBanRequest(line):
            dateTime = getLogDateTime(line)
            ip = getFireWallBanRequestIp(line)
            if not isBannedIp(ip):
                banIp(ip, "'{}' was banned after ban request at {}".format(ip, dateTime))

        elif isRequestConnectionCookie(line):
            dateTime = getLogDateTime(line)
            ip = getRequestConnectionCookieIp(line)
            if (ip not in records) or (records[ip]["time"] != dateTime):
                records[ip] = {}
                records[ip]["count"] = 0
            records[ip]["count"] = records[ip]["count"] + 1
            records[ip]["time"] = dateTime

        elif isModifiedPacket(line):
            dateTime = getLogDateTime(line)
            ip = getModifiedPacketPlayerIp(line)
            if not isBannedIp(ip):
                banIp(ip, "'{}' was banned after modifying packet at {}".format(ip, dateTime))

    for ip in records:
        if (records[ip]["count"] > 8) and (not isBannedIp(ip)):
            banIp(ip, "'{}' was banned after {} tries at {}".format(
                  ip, records[ip]["count"], records[ip]["time"]))

#Create timer and run it
import sched, time

def worker(scheduler):
    scheduler.enter(DELAY, 1, worker, (scheduler,)) # schedule the next call first
    checkLogs(FILE_TO_WATCH, LOG_FILE)

scheduler = sched.scheduler(time.time, time.sleep)
scheduler.enter(DELAY, 1, worker, (scheduler,))
scheduler.run()
