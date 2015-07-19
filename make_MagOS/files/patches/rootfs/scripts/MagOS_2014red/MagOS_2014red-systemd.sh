#!/bin/bash
SERVICESMASK="atd avahi-daemon avahi-dnsconfd ebtables hddtemp ip6tables lircd lircmd \
blk-availability lvm2-activation-early lvm2-activation-net lvm2-activation.service \
mdmonitor nmb ntpd openl2tp snmpd xl2tpd"
for a in $SERVICESMASK ;do
    [ -f lib/systemd/system/$a.service ] &&  ln -s '/dev/null' "etc/systemd/system/$a.service"
done
exit 0
