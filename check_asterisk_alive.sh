#!/bin/sh
#============================== SUMMARY =====================================
#
#Program : check_asterisk_alive
#Version : 0.1
#Date : Feb 10, 2014 
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
ASTPID=`cat $PIDFILE`
ASTRUN=`ps --no-heading p $ASTPID | wc -l`

if [ $ASTRUN = "1"  ]; then
	echo "OK - Asterisk Running on PID $ASTPID"
	exit 0
else
	echo "CRITICAL - Asterisk is not running"
	exit 2
fi
