#!/bin/bash
 cp -pRf dracut_patch/* /usr/lib/dracut/modules.d
[ -f /etc/modprobe.conf ] && mv /etc/modprobe.conf /etc/modprobe.conf.bak
dracut  -m "magos" -c dracut.conf -v -M dracut.cpio.gz $(uname -r)  >dracut.log 2>&1
gunzip -f dracut.cpio.gz
