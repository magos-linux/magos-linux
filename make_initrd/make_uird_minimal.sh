#!/bin/bash
rm -rf /usr/lib/dracut/modules.d/97uird /usr/lib/dracut/modules.d/98magos-soft
cp -pRf dracut_modules/* /usr/lib/dracut/modules.d

dracut  -f -m "base busybox uird"  \
	-d "loop cryptoloop aes-generic aes-i586" \
        --filesystems "aufs squashfs vfat ntfs msdos iso9660 isofs xfs btrfs ext3 ext4 fuse nfs cifs" \
        -c dracut.conf -v -M uird.cpio.xz $(uname -r) >dracut.log 2>&1


