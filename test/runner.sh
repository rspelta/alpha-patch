#!/bin/bash

echo "start PID=${1}"

LOOP=1

while [ ${LOOP} -eq 1 ] 
do
	sleep 60
	STATUS=`ps -p ${1} | grep ${1}`
	[ $? -eq 0 ] || { LOOP=0;  }
	echo -n "."
done

echo "finish"
