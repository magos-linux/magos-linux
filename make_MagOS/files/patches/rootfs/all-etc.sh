#!/bin/bash

sed -i /HOSTNAME=/d etc/sysconfig/network
echo HOSTNAME=$1 >> etc/sysconfig/network
echo SYSTEM=\"$1 Linux\" > etc/sysconfig/oem
echo PRODUCT=$2 >> etc/sysconfig/oem
sed -i /localhost/d etc/hosts
echo "127.0.0.1               localhost $1" >> etc/hosts
echo "127.0.0.1             sb-ssl.l.google.com safebrowsing.clients.google.com safebrowsing.cache.l.google.com" >> etc/hosts
sed -i s/":3:initdefault:"/":5:initdefault:"/ etc/inittab
grep -q " loop127 " etc/udev/devices.d/default.nodes || \
   for a in $(seq 0 127) ;do
       echo "M loop$a         b 7 $a" >>etc/udev/devices.d/default.nodes 
   done
exit 0
