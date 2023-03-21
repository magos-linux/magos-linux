#!/bin/bash
[ -x /usr/sbin/pdnsd ] || exit 0

#BUGFIX
PFP=/var/cache/pdnsd/pdnsd.cache
[ -f $PFP ] && echo -n >$PFP
chown pdnsd:pdnsd $PFP

PFP=/etc/resolv.conf
[ -h "$PFP" ] && rm -f "$PFP"
[ -f "$PFP" ] || touch "$PFP"
sed -i /nameserver/d $PFP
echo "nameserver 127.0.0.1" > $PFP

PFP=/etc/NetworkManager/NetworkManager.conf
if [ -f $PFP ] ;then
   sed -i /^dns=/d $PFP
   sed -i /^\\[main\\]$/s/$/\\ndns=none/ $PFP
fi
exit 0
