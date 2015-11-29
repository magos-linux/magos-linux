#!/bin/sh
PFP=/etc/proftpd.conf
[ -f $PFP ] && sed -i s%'/usr/lib64/proftpd'%'/usr/lib/proftpd'% $PFP
