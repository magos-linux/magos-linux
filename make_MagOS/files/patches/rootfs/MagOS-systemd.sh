#!/bin/bash
SERVICESSTOP=abrtd,hostapd,irqbalance,smartd
for a in $SERVICESSTOP ;do 
   rm -f etc/systemd/system/multi-user.target.wants/$a.service
done

exit 0

