#!/bin/sh
#============================== SUMMARY =====================================
#
#Program : check_peers
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
ONLINE_WARNING=10
ONLINE_CRITICAL=1
OFFLINE_WARNING=100
OFFLINE_CRITICAL=110
while test $# -gt 0; do
	case "$1" in
		-on-w)
			ONLINE_WARNING=$2
			shift
			;;
		-on-c)
			ONLINE_CRITICAL=$2
			shift
			;;
		-off-w)
			OFFLINE_WARNING=$2
			shift
			;;
		-off-c)
			OFFLINE_CRITICAL=$2
			shift
			;;
		*)
			#break
			shift
			;;
	esac
done

ASTBIN="/usr/sbin/asterisk"
ASTLINE=`$ASTBIN -rx 'sip show peers' | grep 'sip peers'`
PEERSONLINE=`echo $ASTLINE | awk '{print $5}'`
PEERSOFFLINE=`echo $ASTLINE | awk '{print $7}'`

if [ $PEERSONLINE -lt $ONLINE_CRITICAL ]; then
	echo "CRITICAL - $PEERSONLINE Peers online"
	exit 1
fi
if [ $PEERSOFFLINE -gt $OFFLINE_CRITICAL ]; then
	echo "CRITICAL - $PEERSOFFLINE Peers offline"
	exit 1
fi
if [ $PEERSONLINE -lt $ONLINE_WARNING ]; then
	echo "WARNING - $PEERSONLINE Peers online"
	exit 1
fi
if [ $PEERSOFFLINE -gt $OFFLINE_WARNING ]; then
	echo "WARNING - $PEERSOFFLINE Peers offline"
	exit 1
fi
echo "OK - $PEERSONLINE peers online, $PEERSOFFLINE peers offline"
exit 0
