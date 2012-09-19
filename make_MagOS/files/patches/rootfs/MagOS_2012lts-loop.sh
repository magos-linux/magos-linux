#!/bin/bash
#ln -sf ../usr/lib/magos/scripts/start_udev sbin/start_udev
if [ ! -e lib/udev/devices/loop127 ] ;then
  for a in $(seq 1 127) ;do 
     mknod lib/udev/devices/loop$a b 7 $a
  done
fi
exit 0
