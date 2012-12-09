#!/bin/bash
#BUGFIX - some printers are added
for PFP in etc/udev/rules.d/40-hplip.rules lib/udev/rules.d/40-hplip.rules ;do
   [ -f $PFP ] || continue
   if ! grep -q "ATTRS{idProduct}==.8711." $PFP ;then
      sed -i /"idProduct.==.7902."/s/$/'\n# DeskJet2050A\nATTRS{idVendor}=="03f0", ATTRS{idProduct}=="8711", GROUP="lp", ENV{ID_HPLIP}="1"'/ $PFP
   fi
   if ! grep -q "ATTRS{idProduct}==.052a." $PFP ;then
      sed -i /"idProduct.==.8711."/s/$/'\n# Laserjet Professional M1212nf MFP\nATTRS{idVendor}=="03f0", ATTRS{idProduct}=="052a", GROUP="lp", ENV{ID_HPLIP}="1"'/ $PFP
   fi
done

#BUGFIX - udev hangup sometimes
ln -sf ../usr/lib/magos/scripts/start_udev sbin/start_udev

exit 0
