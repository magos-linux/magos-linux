#!/bin/bash
#BUGFIX
PFP=etc/rc.d/init.d/polipo
[ -f $PFP ] || exit 0
grep -q "\$remote_fs" $PFP && sed -i s/.\$remote_fs// $PFP
grep -q "Default-Start:" $PFP || sed -i 's|^# Description:|# Default-Start: 2 3 4 5\n# Description:|' $PFP

PFP=etc/polipo/config
[ -f $PFP ] || exit 0
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config
daemonise=true
pidFile=/var/run/polipo/polipo.pid
proxyAddress="127.0.0.1"
proxyPort=8118
allowedClients=192.168.1.0/16, 127.0.0.1
allowedPorts=1-65535
proxyName="localhost"
cacheIsShared=false
chunkHighMark=67108864
diskCacheRoot=""
localDocumentRoot=""
disableLocalInterface=true
disableConfiguration=true
dnsUseGethostbyname=false
disableVia=true
censoredHeaders=from,accept-language,x-pad,link
censorReferer=maybe
maxConnectionAge=5m
maxConnectionRequests=120
serverMaxSlots=8
serverSlots=2
tunnelAllowedPorts=1-65535
# Uncomment this if you want to use a TOR network
#socksParentProxy="localhost:9050"
#socksProxyType=socks5
EOF
exit 0
