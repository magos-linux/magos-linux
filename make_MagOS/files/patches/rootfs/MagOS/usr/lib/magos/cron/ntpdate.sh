#!/bin/bash
. /etc/sysconfig/MagOS
. /etc/sysconfig/network
export PATH=/usr/lib/magos/scripts:/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin

# Do not start while daemon is running
if [ "$NETWORKING" = "yes" ] && ! ps -A | grep -q ntpd$ ;then
  for a in $(echo $NTPSERVERS | tr ',;' ' ') ;do
    ntpdate $a >/dev/null 2>/dev/null && break
  done
fi
