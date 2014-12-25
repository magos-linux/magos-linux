#!/bin/bash
PFP=etc/rc.d/init.d/pdnsd
[ -f $PFP ] || exit 0
grep -q "BEGIN INIT INFO" $PFP || sed -i 's|^# chkconfig:.*|# pdnsd         A caching dns proxy\n#\
# Authors:      Thomas Moestl and others\n#\
# chkconfig: 345 60 40|' $PFP
grep -q "BEGIN INIT INFO" $PFP || sed -i 's|^# description.*|# description:  A caching dns proxy for small networks or dialin accounts\n#\
### BEGIN INIT INFO\
# Provides: pdnsd\
# Required-Start: network\
# Should-Start:.\
# Required-Stop: network\
# Should-Stop:.\
# Default-Start: 2 3 4 5\
# Short-Description: A caching dns proxy\
# Description: A caching dns proxy for small networks or dialin accounts\
### END INIT INFO|' $PFP

PFP=etc/pdnsd.conf
grep -q MagOS $PFP && exit 0
cp -p $PFP ${PFP}_default
cat >$PFP <<EOF
#MagOS default config
global {
	perm_cache=1024;
	cache_dir="/var/cache/pdnsd";
	run_as="pdnsd";
	status_ctl = on;
	min_ttl=15m;       # Retain cached entries at least 15 minutes.
	max_ttl=1w;	   # One week.
	timeout=10;        # Global timeout option (10 seconds).
        server_ip=any;
#       interface=eth0;
}

server {
	label= "ISP";
#	ip = 192.168.1.1;  # Put your ISP's DNS-server address(es) here.
        file="/var/cache/pdnsd/pdnsd.servers";
	proxy_only=on;     # Do not query any name servers beside your ISP's.
	timeout=4;         # Server timeout; this may be much shorter
			   # that the global timeout option.
	uptest=query;
#	interface=eth0;
	interval=30;      # Check every 10 minutes.
	purge_cache=off;   # Keep stale cache entries in case the ISP's
			   # DNS servers go offline.
	preset=off;
}

source {
	owner=localhost;
	file="/etc/hosts";
}

rr {
	name=localhost;
	reverse=on;
	a=127.0.0.1;
	owner=localhost;
	soa=localhost,root.localhost,42,86400,900,86400,86400;
}
EOF
exit 0
