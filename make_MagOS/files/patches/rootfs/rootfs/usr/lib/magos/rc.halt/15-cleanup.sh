#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

# some cleanups
rm -fr /tmp/* /mnt/live/memory/changes/usr/share/apps/ksplash/Themes/Default 2>/dev/null
rm -f /mnt/live/memory/changes/usr/share/magos/wallpapers/default.jpg 2>/dev/null
rm -f /var/lib/rpm/__db* 2>/dev/null

if [ ! -f /mnt/live/memory/changes/var/lib/rpm/Packages ] ;then
   if [ -d /var/lib/rpmdb ] ;then
       # RPM5 vs EXTFS bug workaround
       rsync -a --del /var/lib/rpm/ /var/lib/rpmdb
   else
       # if packages are not changed then delete all changes from /var/lib/rpm
       rm -fr /mnt/live/memory/changes/var/lib/rpm 2>/dev/null
   fi
fi

sync
