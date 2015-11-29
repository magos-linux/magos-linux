#!/bin/bash
/usr/lib/magos/scripts/mkinitrd /boot/initrd.gz
rm -f /lib/modules/*/modules.pcimap
exit 0
