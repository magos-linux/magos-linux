#!/bin/bash
NUM="51-x"
NAME="alvr"
. ../functions || exit 1
ALVRREL=21.0.0dev00-1.git933bfa.1
SOURCE0=http://ftp.magos-linux.ru/rpms/2021/alvr-$ALVRREL-rosa2021.x86_64.rpm
SOURCE1=http://ftp.magos-linux.ru/rpms/2021/lib64alvr-$ALVRREL-rosa2021.x86_64.rpm
SOURCE2=http://ftp.magos-linux.ru/rpms/2021/lib64openxr-1.0.24-1vr-rosa2021.x86_64.rpm
DNFINST="android-tools"

clean

prepare

mkdir -p rootfs/var/lib/rpm/modules cache
cd cache
download $SOURCE0
download $SOURCE1
download $SOURCE2
cd ..
[ ! -z "$DNFINST" ] && dnf -y --downloadonly --skip-broken --destdir cache install $DNFINST || exit 1
rsync -a --delete cache/ $CACHE || exit 1

cd rootfs
for a in $CACHE/*.rpm ;do
   rpm2cpio $a | cpio -i -d 2>/dev/null || exit 1
done
ls -1 $CACHE/*.rpm | sed 's|.*/||' > var/lib/rpm/modules/$NUM-$NAME
cd ../

pack rootfs $(dirname $DIRNAME)/$NUM-$NAME

clean
