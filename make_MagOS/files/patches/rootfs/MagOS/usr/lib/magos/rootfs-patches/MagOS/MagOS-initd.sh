#!/bin/bash

#services to start
INITDNEED="network gpm xinetd virtualbox"

#disable all xinetd.services
find /etc/xinetd.d -type f | sed s%/etc/xinetd.d/%% | while read a ;do
   grep -q service /etc/xinetd.d/$a && chkconfig --del $a 2>/dev/null
done

#disable all init.d services
find /etc/rc.d/init.d -type f | sed s%/etc/rc.d/init.d%% | while read a ;do
   egrep -q 'chkconfig:|### BEGIN INIT INFO' /etc/rc.d/init.d/$a && chkconfig --del $a 2>/dev/null
done

#enable some services
for a in  $INITDNEED  ;do
   [ -f /etc/rc.d/init.d/$a ] && chkconfig --add $a
done

exit 0

