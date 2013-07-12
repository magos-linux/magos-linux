#!/bin/bash
SERVICESSTOP=abrtd,hostapd,irqbalance,smartd
for a in $SERVICESSTOP ;do 
   chroot . systemctl disable $a.service
done

exit 0

