#!/bin/sh
#============================== SUMMARY =====================================
#
#Program : check_channels
#Version : 0.1
#Date : Feb 12, 2014 
#Author : Mario Hernandez - @mariofix 
#Licence : GPL - summary below, full text at http://www.fsf.org/licenses/gpl.txt 
#Requirements: asterisk - bash
#
#=========================== PROGRAM LICENSE =================================
#
#This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
#This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 675 Mass
# Ave, Cambridge, MA 02139, USA.
#

PIDFILE="/var/run/asterisk/asterisk.pid"
if [ ! -f $PIDFILE ]; then
	echo "CRITICAL - PIDFILE does not exist, maybe asterisk is not running"
	exit 1
fi
WARNING=30
CRITICAL=50
RATIO_WARNING=30
RATIO_CRITICAL=40

while test $# -gt 0; do
	case "$1" in
		-w)
			WARNING=$2
			shift
			;;
		-c)
			CRITICAL=$2
			shift
			;;
		*)
			#break
			shift
			;;
	esac
done

ASTBIN="/usr/sbin/asterisk"
ASTLINE=`$ASTBIN -rx 'core show channels'`
CALLS=`echo  "$ASTLINE" | grep 'active calls' |  awk '{print $1}'`
CHANNELS1=`echo "$ASTLINE" | grep 'active channels' | awk '{print $1}'`
CHANNELS2=`echo "$ASTLINE" | wc -l`
CHANNELS2="$[$CHANNELS2-4]"
DIFERENCE="$[CHANNELS1-CHANNELS2]"

if [ $CALLS -gt $CRITICAL ]; then
	echo "CRITICAL - $CALLS calls, $CHANNELS1 channels"
	exit 2
fi
if [ $CALLS -gt $WARNING ]; then
	echo "WARNING - $CALLS calls, $CHANNELS1 channels"
	exit 1
fi
echo "OK - $CALLS calls, $CHANNELS1 channels"
exit 0
