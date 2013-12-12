#!/usr/bin/env python
# -*-  coding:utf-8 -*-

import socket
import fcntl
import struct

def get_local_ip():
    ip = socket.gethostbyname(socket.gethostname())
    return ip

def get_external_ip():
    return ip

def getIPList():
    ips = socket.gethostbyname_ex(socket.gethostname())
    return ips

def get_linux_ip_address(ifname):
    skt = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    pktString = fcntl.ioctl(skt.fileno(), 0x8915, struct.pack('256s', ifname[:15]))
    ipString  = socket.inet_ntoa(pktString[20:24])
    return ipString

print get_linux_ip_address('lo')
print get_linux_ip_address('eth0')

if __name__ == '__main__':
    print '-'*60
    print 'getIP()', getIP()
    print '-'*60
    print 'getIPList()', getIPList()

