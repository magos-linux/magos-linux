#!/bin/bash
for a in $(find etc/modprobe.d/ -type f | grep -v .conf$ ) ;do
    mv $a $a.conf
done
PFP=etc/modprobe.conf
[ -f $PFP -a ! -h $PFP ] && mv $PFP etc/modprobe.d/modprobe.conf
# [ ! -h $PFP ] && ln -s modprobe.d/modprobe.conf etc/modprobe.conf
