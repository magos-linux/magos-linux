#!/bin/bash
for PFP in etc/udev/rules.d/50-udev-default.rules lib/udev/rules.d/50-udev-default.rules ;do
   [ -f $PFP ] || continue
   sed -i /usb_device...MODE/s/66./666/ $PFP
done

#Create loop devices
if [ ! -e lib/udev/devices/loop127 ] ;then
  for a in $(seq 1 127) ;do
      mknod lib/udev/devices/loop$a b 7 $a
  done
fi

#Delete comments
for a in lib/udev/rules.d/*.rules ;do
  sed -i s/[[:space:]]'#'.*// $a
done

exit 0
