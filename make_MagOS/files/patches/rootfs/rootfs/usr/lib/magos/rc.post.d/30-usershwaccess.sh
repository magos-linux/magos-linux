#!/bin/bash
ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0
for a in $(groupmems -l -g users) ;do
    usermod -a -G usb $a
    usermod -a -G video $a
    usermod -a -G audio $a
done

