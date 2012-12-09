#!/bin/bash

#ntpdate
PFP=etc/cron.d/ntpdate
[ -f $PFP ] || echo -e '# Sync time every 10 minutes if enable\n*/10 * * * *  root /usr/lib/magos/cron/ntpdate.sh' >$PFP

PFP=etc/ntp.conf
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config

server ntp1.vniiftri.ru
server ntp2.vniiftri.ru
server ntp3.vniiftri.ru
driftfile /var/lib/ntp/drift
broadcastdelay	0.008

restrict default ignore
restrict 192.168.1.0 mask 255.255.0.0 nomodify notrap
restrict localhost noquerry notrap
restrict ntp1.vniiftri.ru noquerry notrap
restrict ntp2.vniiftri.ru noquerry notrap
restrict ntp3.vniiftri.ru noquerry notrap
EOF
exit 0
