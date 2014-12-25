#!/bin/bash
PFP=etc/tor/torrc
[ -f $PFP ] || exit 0
grep -q MagOS ${PFP} && exit 0
cat >$PFP <<EOF
#MagOS default config
SocksPort 9050
SocksListenAddress 127.0.0.1
AutomapHostsOnResolve 1
TransPort 9040
DNSPort 5353
EOF
exit 0