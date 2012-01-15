#!/bin/bash

for PFP in etc/udev/rules.d/40-hplip.rules lib/udev/rules.d/40-hplip.rules ;do
   [ -f $PFP ] || continue
   if ! grep -q "ATTRS{idProduct}==.8711." $PFP ;then
      sed -i /"idProduct.==.7902."/s/$/'\n# DeskJet2050A\nATTRS{idVendor}=="03f0", ATTRS{idProduct}=="8711", GROUP="lp", ENV{ID_HPLIP}="1"'/ $PFP
   fi
done

for PFP in etc/udev/rules.d/50-udev-default.rules lib/udev/rules.d/50-udev-default.rules ;do
   [ -f $PFP ] || continue
   sed -i /usb_device...MODE/s/66./666/ $PFP
done

grep -q " loop127 " etc/udev/devices.d/default.nodes 2>/dev/null || \
   for a in $(seq 0 127) ;do
       echo "M loop$a         b 7 $a" >>etc/udev/devices.d/default.nodes 
   done

exit 0
