#!/bin/bash
SERVICESMASK="atd abrtd irqbalance smartd bumblebeed crond hddtemp lircd lircmd \
dhcpd6 ip6tables ebtables sshd tor rpcbind hostapd avahi-daemon avahi-dnsconfd ntpd openl2tp snmpd xl2tpd mdmonitor\
NetworkManager-wait-online fedora-loadmodules fedora-storage-init-late fedora-storage-init  blk-availability"
SERVICESFORCEMASK="ldconfig xinetd lvm2-activation-early lvm2-activation-net lvm2-activation smb nmb"
SERVICESSTOP="dhcpd wine"
for a in ${SERVICESMASK} ;do
    [ -f lib/systemd/system/$a.service ] &&  ln -s '/dev/null' "etc/systemd/system/$a.service"
done
for a in $SERVICESSTOP ;do
    [ -f lib/systemd/system/$a.service ] &&  chroot . /bin/systemctl disable $a.service
done
for a in ${SERVICESFORCEMASK} ;do
    ln -s '/dev/null' "etc/systemd/system/$a.service"
done
exit 0
