#!/bin/bash
#BUGFIX
[ -f usr/bin/startlxde ] || exit 0
grep -q XkbLayout usr/bin/startlxde && exit 0
sed -i  '1s|$|\n. /etc/sysconfig/keyboard\nsetxkbmap $XkbLayout -model $XkbModel -option $XkbOptions|' usr/bin/startlxde
exit 0
