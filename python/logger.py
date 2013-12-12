#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Created on 2013-12-12

@author: samuelchen
'''

import logging, logging.handlers
import os
import sys

class LogLevelFilter(object):
    def __init__(self, level):
        self.__level = level

    def filter(self, logRecord):
        return logRecord.levelno <= self.__level

def setLogPath(path='p2python.log'):
    os.environ['P2PYTHON_LOG'] = path

fh = ch = eh = None
log_path = ''
def getLogger(name='P2Python'):

    global fh, ch, eh, log_path

    if not log_path and 'P2PYTHON_LOG' in os.environ:
        log_path = os.environ['P2PYTHON_LOG']
    else:
        log_path = 'p2python.log'
        setLogPath()

    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)

    # create formatter and add it to the handlers
    formatter = logging.Formatter( \
            "%(asctime)s - %(name)s - %(levelname)s - %(message)s")

    # file handler.
    if not fh:
        fh = logging.handlers.TimedRotatingFileHandler(log_path)
        fh.suffix = "%Y%m%d.log"
        fh.setLevel(logging.INFO)
        fh.setFormatter(formatter)
    # console handler
    if not ch:
        ch = logging.StreamHandler(stream=sys.stdout)
        ch.setLevel(logging.DEBUG)
        ch.addFilter(LogLevelFilter(logging.WARN))
        ch.setFormatter(formatter)
    # stderr handler
    if not eh:
        eh = logging.StreamHandler(stream=sys.stderr)
        eh.setLevel(logging.ERROR)
        eh.setFormatter(formatter)

    # add the handlers to logger
    logger.addHandler(ch)
    logger.addHandler(fh)
    logger.addHandler(eh)

    logger.propagate = False
    return logger

if __name__ == '__main__':
    import logger
    log = logger.getLogger()
    log.debug('This is a debug message.')
    log.info('This is a info message.')
    log.error('This is a error message.')
