#!/bin/bash
[ -f etc/ntp.conf ] || exit 0
#ntpdate
PFP=etc/cron.d/ntpdate
[ -f $PFP ] || echo -e '# Sync time every 10 minutes if enable\n*/10 * * * *  root /usr/lib/magos/cron/ntpdate.sh' >$PFP

PFP=etc/ntp.conf
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config
# servers ntp1.vniiftri.ru server ntp2.vniiftri.ru server ntp3.vniiftri.ru
server 89.109.251.21
server 89.109.251.22
server 89.109.251.23
driftfile /var/lib/ntp/drift
broadcastdelay	0.008

restrict default ignore
restrict 192.168.1.0 mask 255.255.0.0 nomodify notrap nopeer
restrict 127.0.0.1 noquerry notrap
restrict 89.109.251.21 noquerry notrap
restrict 89.109.251.22 noquerry notrap
restrict 89.109.251.23 noquerry notrap
EOF
exit 0
