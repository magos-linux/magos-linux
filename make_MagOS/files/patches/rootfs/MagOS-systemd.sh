#!/bin/bash
SERVICESSTOP=abrtd,hostapd,irqbalance,smartd
for a in $SERVICESSTOP ;do 
    ln -s '/dev/null' "etc/systemd/system/$a.service"
done
exit 0
