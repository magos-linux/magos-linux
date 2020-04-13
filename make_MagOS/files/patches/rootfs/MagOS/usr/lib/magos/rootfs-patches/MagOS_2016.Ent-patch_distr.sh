#!/bin/bash
echo $0
find /usr/lib/magos/rootfs-patches/MagOS_2016.Ent -type f -name \*.sh | sort | while read a ;do
   echo $a
   bash $a
done
