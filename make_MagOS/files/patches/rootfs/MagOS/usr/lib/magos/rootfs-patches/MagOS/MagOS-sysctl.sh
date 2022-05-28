#!/bin/bash
PFP=/etc/sysctl.d/88-magos.conf
grep -q ipv6 $PFP 2>/dev/null || echo -e "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1" >$PFP
exit 0
