#!/bin/bash
for a in $(groupmems -l -g users) ;do
    usermod -a -G usb $a
    usermod -a -G video $a
    usermod -a -G audio $a
done
exit 0
