#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

mount_root() {
    . /linuxrc
    
    return 
    modprobe aufs
    modprobe squashfs

    mkdir -p /mnt/livemedia 
    mkdir -p /mnt/live/changes
    mkdir -p /mnt/live/00 /mnt/live/01 /mnt/live/10 /mnt/live/41
    
    mount $base_from /mnt/livemedia
    
    mount /mnt/livemedia/MagOS/base/00-kernel.xzm /mnt/live/00
    mount /mnt/livemedia/MagOS/base/01-firmware.xzm /mnt/live/01
    mount /mnt/livemedia/MagOS/base/10-core.xzm /mnt/live/10
    mount /mnt/livemedia/MagOS/base/41-1-utilities.xzm /mnt/live/41
    
    mount -t aufs -o br=/mnt/live/changes=rw:/mnt/live/41=rr:/mnt/live/10=rr:/mnt/live/01=rr:/mnt/live/00=rr aufs $NEWROOT
    mkdir -p $NEWROOT/proc $NEWROOT/sys $NEWROOT/dev
    #. linuxrc

}

if [ -n "$root" -a -z "${root%%magos:*}" ]; then
    mount_root
fi
:
