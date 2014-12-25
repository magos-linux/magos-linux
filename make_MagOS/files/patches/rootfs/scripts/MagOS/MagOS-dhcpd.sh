#!/bin/bash
PFP=etc/dhcpd.conf
[ -f $PFP ] || exit 0
grep -q MagOS $PFP  && exit 0
cat >$PFP <<EOF
#MagOS default config
allow booting;
allow bootp;
subnet 192.168.1.0 netmask 255.255.255.0 {
	# default gateway
	option routers 192.168.1.31;
	option subnet-mask 255.255.255.0;

	option domain-name "eth0.local.magos-linux.ru";

	# Seting up an ip address is better here
	option domain-name-servers 192.168.1.31;
	option nis-domain "eth0.local.magos-linux.ru";

        range dynamic-bootp 192.168.1.32 192.168.1.191;

	default-lease-time 21600;
	max-lease-time 43200;

        # PXE-specific configuration directives...
        next-server 192.168.1.31;
        filename "/pxelinux.0";
}

subnet 192.168.2.0 netmask 255.255.255.0 {
	# default gateway
	option routers 192.168.2.31;
	option subnet-mask 255.255.255.0;

	option domain-name "wlan0.local.magos-linux.ru";

	# Seting up an ip address is better here
	option domain-name-servers 192.168.2.31;
	option nis-domain "wlan0.local.magos-linux.ru";

        range dynamic-bootp 192.168.2.32 192.168.2.191;

	default-lease-time 21600;
	max-lease-time 43200;

        # PXE-specific configuration directives...
        next-server 192.168.1.31;
        filename "/pxelinux.0";
}
EOF
exit 0
