#!/bin/bash
#pre starting patcher for polybar config

#bar height
screen_size=$(xrandr |grep \* |awk '{print $1}')
height=$(echo $screen_size |cut -d x -f2)
MARK_HEIGHT=$(($height / 40 ))


#battery
MARK_BATTERY=$(ls /sys/class/power_supply |grep BAT |tail -n1)
MARK_ADAPTER=$(ls /sys/class/power_supply |grep -v BAT |tail -n1)
[ -z $MARK_BATTERY ] && MARK_BATTERY=BAT0 
[ -z $MARK_ADAPTER ] && MARK_ADAPTER=ADP1

#home
MARK_HOME=''
cat /proc/mounts |grep -q ' /home ' && MARK_HOME="mount-1 = /home"

#patcher
cat $(dirname $0)/polybar.cfg | sed \
	-e "s/MARK_HEIGHT/$MARK_HEIGHT/" \
	-e "s/MARK_BATTERY/$MARK_BATTERY/" \
	-e "s/MARK_ADAPTER/$MARK_ADAPTER/" \
	-e "s/MARK_HOME/$MARK_HOME/" \
	> /tmp/polybar.cfg

polybar example -c /tmp/polybar.cfg 
