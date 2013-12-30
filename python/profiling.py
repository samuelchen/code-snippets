#!/usr/bin/env python
# -*- coding : utf-8 -*-

'''
Created on 2013-12-30

@author: samuelchen
'''
import cProfile as profile
import os

class profiling(object):
    _prof = None
    _log = './profiling.log'
    _enabled = False
    
    @classmethod
    def dump_stats(cls):
        if not cls._enabled:
            print '@profiling is not enabled.'
            f = open(cls._log, 'w')
            f.write('@profiling is not enabled.')
            f.close()
            return
        
        print '@profiling is dumping stats to %s' % cls._log
        cls._prof.dump_stats(cls._log)
        
    @classmethod
    def set_log_path(cls, path):
        cls._log = path
        
    @classmethod
    def enable(cls, value):
        cls._enabled = value
    
    def __new__(cls, *args, **kwargs):
        if not cls._prof:
            cls._prof = profile.Profile()
        instance = super(profiling, cls).__new__(cls, *args, **kwargs)
        instance._prof = cls._prof
        return instance
    
    def __init__(self, func, *args, **kwargs):
        self._func = func
                
    def __call__(self, *args, **kwargs):
        if not self._enabled:
            return self._func(*args, **kwargs)
        
        print '@profiling %s' % self._func.__name__
        self._prof.enable()
        ret = self._func(*args, **kwargs)
        self._prof.disable()
        return ret

@profiling
def a(path):
    print 'in a'
    f = open(path, 'r')
    print reduce(lambda x,y: x+y, map(lambda x:len(x), f))
    f.close()
    x = b(10)
    print x

@profiling
def b(mm):
    print 'in b'
    ret = reduce(lambda x,y:x + y, range(mm))
    return ret

if __name__ == '__main__':
    profiling.enable(True)
    a('C:\\Windows\\WindowsUpdate.log')
    profiling.dump_stats()