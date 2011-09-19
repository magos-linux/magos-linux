#!/bin/bash
PFP=etc/ntp.conf
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config
server	127.127.1.0	# local clock
fudge	127.127.1.0 stratum 10

server ntp2.vniiftri.ru
server ntp3.vniiftri.ru
server ru.pool.ntp.org

driftfile /var/lib/ntp/drift
multicastclient			# listen on default 224.0.1.1
broadcastdelay	0.008

restrict default ignore
restrict 192.168.1.0 mask 255.255.0.0 nomodify notrap
EOF
exit 0
