#!/bin/bash
. .config || exit 1
rpm -e --nodeps kernel-headers
cd ../$(basename $PWD | sed s/mods_//)
rpm -ihv --noscripts rpms/*.rpm
ln -sf /usr/src/linux-$KERN /lib/modules/$KERN/build
ln -sf /usr/src/linux-$KERN /lib/modules/$KERN/source
