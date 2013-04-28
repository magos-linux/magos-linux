#!/bin/bash
ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0
USERGROUPS=audio,video,usb,vboxusers,cdrom
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS
if [ "$DOMAINUSERSHWACCESS" ] ;then
  for a in $(echo "$DOMAINUSERSHWACCESS" | tr ",;" " ") ;do
    for b in $(echo "$USERGROUPS" | tr ",;" " ") ;do
       usermod -a -G $b $a
    done
  done
fi
