#!/bin/bash
PFP=usr/bin/proxychains
[ -f $PFP ] || exit 0
LDP=usr/lib
[ -d /usr/lib64 ] && LDP=usr/lib64
sed -i s%LD_PRELOAD=.*libproxychains%"LD_PRELOAD=/$LDP/libproxychains"% $PFP
exit 0
