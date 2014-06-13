#!/bin/usr/env python
# coding:utf-8


import sys
import time

x = ['\\', '/', '-']
for i in range(50):
        j = i % 3
        sys.stdout.write('File x is downloading .. %s [' % x[j])
        sys.stdout.write('=' * i)
        sys.stdout.write('-')
        sys.stdout.write(' ' * (49-i))
        sys.stdout.flush()
        sys.stdout.write('] ')
        time.sleep(0.1)
        sys.stdout.write('\r')
        sys.stdout.flush()

print
