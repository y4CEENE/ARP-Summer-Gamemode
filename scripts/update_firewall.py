#!/usr/bin/env python
# Block all google servers and google cloud ips
import json
import os
import requests

google = 'https://www.gstatic.com/ipranges/goog.json'
gCloud = 'https://www.gstatic.com/ipranges/cloud.json'

blacklistIPV4 = []
blacklistIPV6 = []
rGoogle = requests.get(google)
if rGoogle.status_code != 200:
    print(f"Failed to get google server's ips: rc={rGoogle.status_code}")
else
    rCloud = requests.get(gCloud)
    if rCloud.status_code != 200:
        print(f"Failed to get google cloud ips: rc={rCloud.status_code}")
    else
        jGoogle = json.loads(rGoogle.content)
        for prefix in jGoogle["prefixes"]:
            if "ipv4Prefix" in prefix:
                blacklistIPV4.append(prefix["ipv4Prefix"])
            elif "ipv6Prefix" in prefix:
                blacklistIPV6.append(prefix["ipv6Prefix"])
        jCloud  = json.loads(rCloud.content)
        for prefix in jCloud["prefixes"]:
            if "ipv4Prefix" in prefix:
                blacklistIPV4.append(prefix["ipv4Prefix"])
            elif "ipv6Prefix" in prefix:
                blacklistIPV6.append(prefix["ipv6Prefix"])
        if len(blacklistIPV4) > 0:
            print("Clearing IPV4 iptables")
            os.system("sudo /sbin/iptables -P INPUT ACCEPT")
            os.system("sudo /sbin/iptables -P OUTPUT ACCEPT")
            os.system("sudo /sbin/iptables -P FORWARD ACCEPT")
            os.system("sudo /sbin/iptables -F")
            for ip in blacklistIPV4:
                os.system("/sbin/iptables -A INPUT -s " + ip + " -j DROP")
        if len(blacklistIPV6) > 0:
            print("Clearing IPV6 iptables")
            os.system("sudo /sbin/ip6tables -P INPUT ACCEPT")
            os.system("sudo /sbin/ip6tables -P OUTPUT ACCEPT")
            os.system("sudo /sbin/ip6tables -P FORWARD ACCEPT")
            os.system("sudo /sbin/ip6tables -F")
            for ip in blacklistIPV6:
                os.system("/sbin/ip6tables -A INPUT -s " + ip + " -j DROP")
