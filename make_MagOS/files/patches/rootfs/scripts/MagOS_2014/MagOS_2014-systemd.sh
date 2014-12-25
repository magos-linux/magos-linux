#!/bin/bash
SERVICESMASK="atd avahi-daemon avahi-dnsconfd crond ebtables hddtemp ip6tables lircd lircmd \
lvm2-activation-early lvm2-activation-net lvm2-activation mdmonitor nmb ntpd openl2tp rpcbind snmpd tor wine xinetd xl2tpd"
for a in $SERVICESMASK ;do
    [ -f lib/systemd/system/$a.service ] &&  ln -s '/dev/null' "etc/systemd/system/$a.service"
done
exit 0
