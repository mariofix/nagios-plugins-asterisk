#!/bin/sh
ASTPID=`cat /var/run/asterisk/asterisk.pid`
ASTRUN=`ps --no-heading p $ASTPID | wc -l`

if [ $ASTRUN = "1"  ]; then
	echo "OK - Asterisk Running on PID $ASTPID"
	exit 0
else
	echo "CRITICAL - Asterisk is not running"
	exit 1
fi
