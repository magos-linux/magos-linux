#!/bin/bash
SERVICESDISABLE="adb atd abrtd irqbalance smartd bumblebeed crond hddtemp lircd lircmd \
dhcpd6 ip6tables ebtables sshd tor rpcbind hostapd avahi-daemon avahi-dnsconfd ntpd openl2tp snmpd xl2tpd mdmonitor\
fedora-loadmodules fedora-storage-init-late fedora-storage-init  blk-availability shorewall rtkit-daemon \
canberra-system-bootup canberra-system-shutdown-reboot canberra-system-shutdown \
lvm2-lvmetad lvm2-monitor network dracut-shutdown fedora-readonly lm_sensors \
ldconfig xinetd lvm2-activation-early lvm2-activation-net lvm2-activation smb nmb remount-rootfs \
NetworkManager-wait-online arp-ethers.service dbus-org.freedesktop.Avahi dhcpd wine systemd-resolved ntpdate openswan"
SOCKETSDISABLE="avahi-daemon rpcbind lvm2-lvmetad"
SERVICESSTART="virtualbox"

for a in $SERVICESDISABLE ;do
   find /etc/systemd/system | grep /$a.service | xargs rm -f
   find /lib/systemd/system | grep [.]wants/$a.service | xargs rm -f
done
for a in $SOCKETSDISABLE ;do
   find /etc/systemd/system | grep /$a.socket | xargs rm -f
   find /lib/systemd/system | grep [.]wants/$a.socket | xargs rm -f
done
for a in $SERVICESSTART ;do
    [ -f /lib/systemd/system/$a.service ] &&  systemctl enable $a.service
done

PFP=/etc/systemd/system.conf
sed -i /^DefaultTimeoutStopSec/d $PFP
echo DefaultTimeoutStopSec=10s >> $PFP

PFP=/etc/systemd/coredump.conf
sed -i /Storage=/d $PFP
echo Storage=none >> $PFP

PFP=/lib/systemd/network/90-enable.network
sed -i /DHCP=/d $PFP
echo DHCP=ipv4 >> $PFP

PFP=/lib/systemd/network/90-wireless.network
sed -i /DHCP=/d $PFP
echo DHCP=ipv4 >> $PFP

PFP=/etc/systemd/resolved.conf
sed -i /FallbackDNS/d $PFP
echo "FallbackDNS=77.88.8.8 77.88.8.1" >> $PFP
sed -i /^LLMNR/d $PFP
echo "LLMNR=no" >> $PFP

for a in sddm kdm gdm lightdm slim ;do
    [ -f /lib/systemd/system/$a.service ] || continue
    ln -sf /lib/systemd/system/$a.service /etc/systemd/system/display-manager.service && break
done

PFP=lib/systemd/system/laptop-mode.service
grep -q ConditionPathExists=/sys/class/power_supply/BAT0 $PFP || sed -i /Description/s%$%\\nConditionPathExists=/sys/class/power_supply/BAT0% $PFP

PFP=/lib/systemd/system/systemd-udevd.service
sed -i s/^MountFlags=.*/MountFlags=shared/ $PFP

for a in dhcpd ntpd ;do
   PFP=/lib/systemd/system/$a.service
   [ -f $PFP ] || continue
   grep -q network-online.target $PFP || sed -i s/After=/"After=network-online.target "/ $PFP
done

rm -f /lib/udev/rules.d/51-android.rules 2>/dev/null

exit 0
