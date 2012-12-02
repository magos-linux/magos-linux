#!/bin/bash
. /etc/sysconfig/MagOS
. /etc/sysconfig/network
export PATH=/usr/lib/magos/scripts:/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin

[ "$NETWORKING" != "yes" ] && exit 0

# Do not start while daemon is running
ps -A | grep -q ntpd$ && exit 0

for a in $(echo $NTPSERVERS | tr ',;' ' ') ;do
    ntpdate $a >/dev/null 2>/dev/null && break
done
