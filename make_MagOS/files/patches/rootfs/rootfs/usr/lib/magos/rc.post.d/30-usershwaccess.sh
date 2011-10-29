#!/bin/bash
for a in $(groupmems -l -g users) ;do
    usermod -a -G usb $a
done
exit 0
