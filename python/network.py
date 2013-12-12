#!/usr/bin/env python
# -*-  coding:utf-8 -*-

''
Created on 2013-12-12
@samuelchen
'''

import sys

_is_window = sys.platform.startswith('win')
_is_linux =  sys.platform.startswith('linux')
_is_mac =  sys.platform.startswith('darwin')

import socket
if not _is_window: import fcntl
import struct

def get_local_ip():
    ''' return local ip address'''
    ip = ''
    if _is_linux:
        ip = get_linux_ip_address('lo')
    else:
        ip = socket.gethostbyname(socket.gethostname())
    return ip

def get_external_ip():
    ''' return external ip address if has. otherwise, return local ip address.'''
    ip = ''
    if _is_linux:
        ip = get_linux_ip_address('eth0')
    else:
        ip = socket.gethostbyname(socket.gethostname())
    return ip

def get_ip_list():
    ips = socket.gethostbyname_ex(socket.gethostname())
    return ips

def get_linux_ip_address(ifname):
    ''' return an ip address by network interface name.
        for linux only
    '''
    skt = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    pktString = fcntl.ioctl(skt.fileno(), 0x8915, struct.pack('256s', ifname[:15]))
    ipString  = socket.inet_ntoa(pktString[20:24])
    return ipString


if __name__ == '__main__':
    print '-'*60
    print 'get_local_ip()', get_local_ip()
    print 'get_external_ip()', get_external_ip()
    print 'get_ip_list()', get_ip_list()
    print '-'*60

