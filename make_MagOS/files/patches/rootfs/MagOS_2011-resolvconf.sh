#!/bin/bash
PFP=etc/resolvconf/resolv.conf.d/head
grep -q "127\.0\.0\.1" $PFP || echo "nameserver 127.0.0.1" >> $PFP
exit 0
