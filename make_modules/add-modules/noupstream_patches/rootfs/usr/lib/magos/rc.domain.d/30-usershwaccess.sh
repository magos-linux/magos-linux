#!/bin/bash
ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0
USERGROUPS=audio,video,usb,vboxusers
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS
[ -z "$DOMAINUSERSHWACCESS" ] && exit 0
for a in $(echo "$DOMAINUSERSHWACCESS" | tr ",;" " ") ;do
    usermod -a -G $USERGROUPS $a
done
