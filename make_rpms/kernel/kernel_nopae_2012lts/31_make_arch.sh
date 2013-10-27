#!/bin/bash
. .config
mkinitrd xzmbuild/MagOS/initrd.gz $KERN
dir2xzm xzmbuild/kernel xzmbuild/MagOS/base/00-kernel.xzm
dir2xzm xzmbuild/kernel-devel xzmbuild/MagOS/base/14-devel-kernel-nopae.xzm
cd xzmbuild/MagOS/base
md5sum * >MD5SUM.nopae
cd ../../../
cp /mnt/live/VERSION xzmbuild/MagOS
chmod -R a-w xzmbuild/MagOS
NAME=MagOS_$(cat /mnt/live/VERSION | tr " " _)-nopae
mkdir -p nopae/$NAME
cp -pfr xzmbuild/MagOS nopae/$NAME
cd nopae
tar -czf $NAME.tar.gz $NAME
md5sum $NAME.tar.gz > $NAME.tar.gz.md5
rm -fr "./$NAME"
cd ../
echo Done
