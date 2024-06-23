#!/bin/bash
NUM="51-x"
NAME="yandex-browser"
. ../functions || exit 1

clean

prepare

mkdir -p rootfs/var/lib/rpm/modules cache
dnf -y --downloadonly --destdir cache install $NAME
rsync -a --delete cache/ $CACHE || exit 1

cd rootfs
for a in $CACHE/*.rpm ;do
   rpm2cpio $a | cpio -i -d 2>/dev/null || exit 1
done
rm -fr "etc"
ls -1 $CACHE/*.rpm | sed 's|.*/||' > var/lib/rpm/modules/$NUM-$NAME
cd ../

pack rootfs $(dirname $DIRNAME)/$NUM-$NAME

clean
