#!/bin/bash
NUM="51-x"
NAME="portproton"
. ../functions || exit 1

clean

prepare

mkdir -p rootfs/var/lib/rpm/modules cache
dnf -y --downloadonly --destdir cache install portproton
rm -f cache/vulkan-*86.rpm cache/vkd3d-*86.rpm
rsync -a --delete cache/ $CACHE || exit 1

cd rootfs
for a in $CACHE/*.rpm ;do
   rpm2cpio $a | cpio -i -d 2>/dev/null || exit 1
done
ls -1 $CACHE/*.rpm | sed 's|.*/||' > var/lib/rpm/modules/$NUM-$NAME
cd ../

pack rootfs $(dirname $DIRNAME)/$NUM-$NAME

clean
