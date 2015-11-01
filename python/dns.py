#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys, socket

# need dnspython
import dns.resolver
import dns.name
import dns.reversename
import dns.update
import dns.query
import dns.tsigkeyring

def resolve(domain):
    result = dns.reversename.to_address(domain)
    print result
    return result

def resolve1(domain):
    result=socket.getaddrinfo(domain, None)
    print result
    return result

def check_mx(domain):
    answers = dns.resolver.query('nominum.com', 'MX')
    for rdata in answers:
        print 'Host', rdata.exchange, 'has preference', rdata.preference
    return answers

def ddns(dns_ip, domain, ip, tsigkey_name, tsigkey):

   keyring = dns.tsigkeyring.from_text({
       tsigkey_name : tsigkey
       })
   update = dns.update.Update('example.', keyring=keyring)
   update.replace(ip, 300, 'A', sys.argv[1])
   response = dns.query.tcp(update, dns_ip, timeout=10)

def ddns1(domain):
    '''
    update dnspod dns by using current IP
    '''

    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/json"}
    conn = httplib.HTTPSConnection(domain, timeout=30)
    conn.request("POST", "/Record.Ddns", urllib.urlencode(ddns_params), headers)

    response = conn.getresponse()
    # print response.status, response.reason
    # data = response.read()
    # print data
    conn.close()
    return response.status == 200"
