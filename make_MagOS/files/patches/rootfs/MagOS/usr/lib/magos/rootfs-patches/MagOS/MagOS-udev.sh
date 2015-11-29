#!/bin/bash

mkdir -m 755 -p /run/udev/rules.d

#FIXME delete
#for PFP in etc/udev/rules.d/50-udev-default.rules lib/udev/rules.d/50-udev-default.rules ;do
#   [ -f $PFP ] || continue
#   sed -i /usb_device...MODE/s/66./666/ $PFP
#done

#FIXME doesnt work for ROSA
#Create loop devices
if [ ! -e /lib/udev/devices/loop127 ] ;then
  for a in $(seq 1 127) ;do
      mknod /lib/udev/devices/loop$a b 7 $a
  done
fi

#BUGFIX bad rpm  workaround
#Delete comments
for a in /lib/udev/rules.d/*.rules ;do
  grep -q .'#' $a &&  sed -i s/[[:space:]]'#'.*// $a
done

exit 0
