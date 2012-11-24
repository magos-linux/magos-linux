#!/bin/bash
PFP=usr/bin/proxychains
sed -i s%LD_PRELOAD=.*libproxychains%'LD_PRELOAD=/usr/lib/libproxychains'% $PFP
exit 0
