#!/bin/bash
#pre starting patcher for polybar config

#bar height
height=$(xrandr --listactivemonitors |grep -vi monitor |head -n1 |cut -d ' ' -f4 |sed -e 's/+.*//' -e 's/^.*x//' )
MARK_HEIGHT=$( expr  $(echo $height |cut -d '/' -f1)  \* 6 \/ $(echo $height |cut -d '/' -f2) )
expr $MARK_HEIGHT + 1  >/dev/null || MARK_HEIGHT=22 


#battery
MARK_BATTERY=$(ls /sys/class/power_supply |grep BAT |tail -n1)
MARK_ADAPTER=$(ls /sys/class/power_supply |grep -v BAT |tail -n1)
[ -z $MARK_BATTERY ] && MARK_BATTERY=BAT0 
[ -z $MARK_ADAPTER ] && MARK_ADAPTER=ADP1

#home
MARK_HOME=''
cat /proc/mounts |grep -q ' /home ' && MARK_HOME="mount-1 \= \/home"

#patcher
cat $(dirname $0)/polybar.cfg | sed \
	-e "s/MARK_HEIGHT/$MARK_HEIGHT/" \
	-e "s/MARK_BATTERY/$MARK_BATTERY/" \
	-e "s/MARK_ADAPTER/$MARK_ADAPTER/" \
	-e "s/MARK_HOME/$MARK_HOME/" \
	> /tmp/polybar.cfg

polybar panel -r -c /tmp/polybar.cfg & 
polybar tray -r -c /tmp/polybar.cfg &
