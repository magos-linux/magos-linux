#!/bin/bash
ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS
[ -z "$DOMAINUSERSHWACCESS" ] && exit 0
for a in $(echo "$DOMAINUSERSHWACCESS" | tr ",;" " ") ;do
    usermod -a -G usb $a
    usermod -a -G users $a
    usermod -a -G audio $a
    usermod -a -G video $a
done
