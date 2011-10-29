#!/bin/bash
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS
[ -z "$DOMAINUSERSHWACCESS" ] && exit 0
for a in $(echo "$DOMAINUSERSHWACCESS" | tr ",;" " ") ;do
    usermod -a -G usb $a
    usermod -a -G users $a
done
exit 0
