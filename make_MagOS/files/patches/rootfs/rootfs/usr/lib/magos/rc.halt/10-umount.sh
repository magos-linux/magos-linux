#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

PATH=/usr/lib/magos/scripts:$PATH

swapoff -a >/dev/null 2>/dev/null

# umount any modules from /media
for a in `losetup -a | grep '(/media/.*.[lx]zm)' | awk '{print $3}' | tr -d '()'` ;do
    deactivate $a
done
# then free any /media
for a in /home `grep /media/ /proc/mounts  | awk '{print $2}'` `grep " /mnt/" /proc/mounts | grep -v /mnt/live | awk '{print $2}'` ;do
    grep -q " $a " /proc/mounts || continue
    umount $a
    grep -q " $a " /proc/mounts || continue
    #move unmounted partitions
    mkdir -p /mnt/live/mnt/unmounted$a
    mount --move $a /mnt/live/mnt/unmounted$a
done

for a in /media/* ;do rmdir $a >/dev/null 2>&1 ;done

