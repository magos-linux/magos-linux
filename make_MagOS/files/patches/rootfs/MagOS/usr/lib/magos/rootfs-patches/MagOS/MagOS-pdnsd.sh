#!/bin/bash
#BUGFIX
PFP=/var/cache/pdnsd/pdnsd.cache
[ -f $PFP ] && echo -n >$PFP
chown pdnsd.pdnsd $PFP
exit 0
