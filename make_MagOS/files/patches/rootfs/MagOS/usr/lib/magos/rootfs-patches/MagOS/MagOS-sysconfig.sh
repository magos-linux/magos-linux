#!/bin/bash
SCP=/etc/sysconfig

[ -d $SCP ] || exit 0

echo "COMPOSITING_SERVER_START=no" > $SCP/compositing-server
echo "COMPOSITING_WM_START=no" > $SCP/compositing-wm
echo "FINISH_INSTALL=no" > $SCP/finish-install
echo "FIRSTBOOT=no" > $SCP/firstboot
echo "USE_LOCARCHIVE=no" > $SCP/locales
echo -e "UTC=false\nARC=false\nZONE=Europe/Moscow" >$SCP/clock
echo -e "MOUSETYPE=ps2\ndevice=input/mice" >$SCP/mouse
echo -e "NETWORKING=yes\nCRDA_DOMAIN=RU\nNETWORKING_IPV6=NO" >$SCP/network
echo -e "SYSTEM=MagOS-Linux\nPRODUCT=2016" >$SCP/oem

cat >$SCP/i18n <<EOF
LC_TELEPHONE=ru_RU.UTF-8
LC_CTYPE=ru_RU.UTF-8
LANGUAGE=ru_RU.UTF-8:ru
LC_MONETARY=ru_RU.UTF-8
LC_ADDRESS=ru_RU.UTF-8
LC_COLLATE=ru_RU.UTF-8
LC_PAPER=ru_RU.UTF-8
LC_NAME=ru_RU.UTF-8
LC_NUMERIC=ru_RU.UTF-8
SYSFONT=UniCyr_8x16
LC_MEASUREMENT=ru_RU.UTF-8
LC_TIME=ru_RU.UTF-8
LANG=ru_RU.UTF-8
LC_IDENTIFICATION=ru_RU.UTF-8
LC_MESSAGES=ru_RU.UTF-8
EOF

cat >$SCP/keyboard <<EOF
XkbModel=pc105
GRP_TOGGLE=ctrl_shift_toggle
XkbLayout="us,ru"
KEYBOARD=ru
KEYTABLE=ru4
XkbOptions=grp:ctrl_shift_toggle,grp_led:scroll,compose:rwin
EOF

cat >$SCP/modem <<EOF
# Autorun dialup applications on device hotplug
INTERACTIVE=no
# Time to detect provider
TIMEOUT=60
#PORT=/dev/modem
# Collect and show session statistic
STAT=yes
# Autoup network on device connection
#INETAUTOUP=yes
EOF

cat >$SCP/pulseaudio <<EOF
# Set the below variable to suit your needs.
# Possible values are:
#   personal  Start a personal pulseaudio server per-user (recommended)
#   system    Start a system wide daemon (not yet implemented)
#   none      Don't start pulse
# NB For the system wide daemon, users need to be in the group pulse-access.
PULSE_SERVER_TYPE=none
# Set the various arguments to the daemon here
#  This defaults to:
#  --log-target=syslog for "personal"
#PULSE_ARGS=
EOF

cat >$SCP/readahead <<EOF
# enable readahead at system startup
READAHEAD="no"
# enable (monthly) readahead list collection
READAHEAD_COLLECT="no"
# collect x seconds more after prefdm started
READAHEAD_EXTRA_COLLECT="10"
# collect on rpm database change
READAHEAD_COLLECT_ON_RPM="yes"
EOF

ln -sf ../MagOS/services/iptables $SCP/iptables

[ -d $SCP/harddrake2 ] && echo AUTORECONFIGURE_RIGHT_XORG_DRIVER=no > $SCP/harddrake2/service.conf

[ -d $SCP/network-scripts ] || exit 0

cat >$SCP/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
METRIC=5
MII_NOT_SUPPORTED=no
USERCTL=yes
RESOLV_MODS=no
LINK_DETECTION_DELAY=6
IPV6INIT=no
IPV6TO4INIT=no
DHCP_CLIENT=dhclient
NEEDHOSTNAME=no
PEERDNS=yes
PEERYP=yes
PEERNTPD=no
NM_CONTROLLED=yes
ACCOUNTING=no
EOF

cat >$SCP/network-scripts/ifcfg-wlan0 <<EOF
DEVICE=wlan0
BOOTPROTO=dhcp
ONBOOT=no
METRIC=35
MII_NOT_SUPPORTED=no
USERCTL=yes
RESOLV_MODS=no
WIRELESS_MODE=Managed
WIRELESS_ESSID=
IPV6INIT=no
IPV6TO4INIT=no
ACCOUNTING=no
DHCP_CLIENT=dhclient
NEEDHOSTNAME=no
PEERDNS=yes
PEERYP=yes
PEERNTPD=no
NM_CONTROLLED=yes
EOF

[ -d $SCP/network-scripts/wireless.d ] || exit 0

cat >$SCP/network-scripts/wireless.d/MagOS <<EOF
BOOTPROTO=dhcp
USERCTL=yes
RESOLV_MODS=no
WIRELESS_MODE=Managed
WIRELESS_ESSID=MagOS
WIRELESS_ENC_KEY=magoslinux
WIRELESS_WPA_DRIVER=wext
WIRELESS_WPA_REASSOCIATE=no
DHCP_CLIENT=dhclient
PEERDNS=yes
PEERYP=yes
PEERNTPD=no
EOF

exit 0
