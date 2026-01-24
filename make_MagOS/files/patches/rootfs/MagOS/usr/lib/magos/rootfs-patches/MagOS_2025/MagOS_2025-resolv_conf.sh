#!/bin/bash
PFP=/etc/resolv.conf
[ -h "$PFP" ] && rm -f "$PFP"
echo "nameserver 77.88.8.8" > $PFP

chkconfig --del pdnsd

rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service

