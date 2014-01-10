#!/bin/bash
rm -rf /usr/lib/dracut/modules.d/96magos /usr/lib/dracut/modules.d/97uird /usr/lib/dracut/modules.d/98magos-soft dracut.cpio.xz
cp -pRf dracut_modules/* /usr/lib/dracut/modules.d
[ -f /etc/modprobe.conf ] && mv /etc/modprobe.conf /etc/modprobe.conf.bak
dracut  -m "base busybox uird magos-soft"  \
	-d "loop cryptoloop aes-generic aes-i586 dmcrypt" \
        --filesystems "aufs squashfs vfat ntfs msdos fuse xfs btrfs nls_cp866 nls_utf8" \
        -c dracut.conf -v -M dracut.cpio.xz $(uname -r) >dracut.log 2>&1

#cp -Rf dracut.cpio.xz /mnt/livemedia/MagOS/dracut.cpio.xz

