#!/bin/bash

sed -i s/":3:initdefault:"/":5:initdefault:"/ etc/inittab
grep -q " loop127 " etc/udev/devices.d/default.nodes 2>/dev/null || \
   for a in $(seq 0 127) ;do
       echo "M loop$a         b 7 $a" >>etc/udev/devices.d/default.nodes 
   done
exit 0
