#!/bin/bash

#services to start
INITDNEED="gpm xinetd virtualbox pdnsd"

#disable all xinetd.services
find /etc/xinetd.d -type f | sed s%/etc/xinetd.d/%% | while read a ;do
   grep -q service /etc/xinetd.d/$a && chkconfig --del $a 2>/dev/null
done

#disable all init.d services
RCPATH=/etc/rc.d/init.d
[ -d $RCPATH ] || RCPATH=/etc/init.d
find $RCPATH -type f | sed s%$RCPATH/%% | while read a ;do
   grep -qE 'chkconfig:|### BEGIN INIT INFO' $RCPATH/$a && chkconfig --del $a 2>/dev/null
done

#enable some services
for a in  $INITDNEED  ;do
   [ -f /etc/rc.d/init.d/$a -o -f /etc/init.d/$a ] && chkconfig --add $a
done

exit 0

