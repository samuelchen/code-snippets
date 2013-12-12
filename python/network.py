#!/usr/bin/env python
# -*-  coding:utf-8 -*-

import sys

_is_window = sys.platform.startswith('win')
_is_linux =  sys.platform.startswith('linux')
_is_mac =  sys.platform.startswith('darwin')

import socket
if not _is_window: import fcntl
import struct

def get_local_ip():
    ip = socket.gethostbyname(socket.gethostname())
    return ip

def get_external_ip():
    return ip

def get_ip_list():
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
    print 'get_local_ip()', get_local_ip()
    print 'get_external_ip()', get_external_ip()
    print '-'*60

