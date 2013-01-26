#!/bin/bash


mkdir /magos /magos-ro /mnt
mount /dev/sda1 /mnt

mount -t tmpfs  tmpfs /magos
mount -o loop /mnt/MagOS/base/10-core.xzm /magos-ro
mount -t aufs -o nowarn_perm,br:/magos=rw:/magos-ro=ro aufs /sysroot

exit 0