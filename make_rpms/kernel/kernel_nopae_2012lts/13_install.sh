#!/bin/bash
. .config
mkdir -p rpms/kernel xzmbuild/kernel xzmbuild/kernel-devel xzmbuild/MagOS/base tmp
mv rpms/kernel-*.rpm rpms/kernel 2>/dev/null
cd tmp
cat ../rpms/kernel/$(ls -S ../rpms/kernel | head -1) | rpm2cpio - | cpio -i -d && mv * ../xzmbuild/kernel || exit 1
cat ../rpms/kernel/kernel-headers-* | rpm2cpio - | cpio -i -d || exit 1
cat $(ls ../rpms/kernel/*devel* | grep -v latest) | rpm2cpio - | cpio -i -d && mv * ../xzmbuild/kernel-devel || exit 1
cd ../
mv xzmbuild/kernel/boot/vmlinuz-* xzmbuild/MagOS/vmlinuz || exit 1
ln -sf /usr/src/linux-$KERN xzmbuild/kernel/lib/modules/$KERN/source
ln -sf /usr/src/linux-$KERN xzmbuild/kernel/lib/modules/$KERN/build
ln -sf "$PWD/xzmbuild/kernel/lib/modules/$KERN" /lib/modules
cp -pfr xzmbuild/kernel-devel/* /
rmdir tmp
echo Done.