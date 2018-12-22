#!/bin/sh
#BUGFIX dhcpd doesn't start without DB file
PFP=/var/lib/dhcpd/dhcpd.leases
if ! [ -f $PFP ] ;then
   touch $PFP
   chown isc-dhcpd.isc-dhcpd $PFP
fi
exit 0
