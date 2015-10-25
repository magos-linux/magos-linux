#!/bin/bash
#BUGFIX
[ -f usr/bin/startlxde ] || exit 0
grep -q XkbLayout usr/bin/startlxde && exit 0
sed -i  '1s|$|\n. /etc/sysconfig/keyboard\nsetxkbmap $XkbLayout -model $XkbModel -option $XkbOptions|' usr/bin/startlxde

#free space by using common icon theme
if [ -d usr/share/icons/rosa -a -d usr/share/icons/rosa-flat ] ;then
   rm -fr usr/share/icons/rosa-flat
   ln -sf rosa usr/share/icons/rosa-flat
fi

