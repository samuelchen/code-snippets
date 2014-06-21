#!/usr/bin/env sh

# get all pids of a given pattern
pattern=${1}
pid=`ps -ef|grep ${pattern}|grep -v ${0}|grep -v grep|awk '{print $2}'`

echo ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} $pid
${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} $pid

