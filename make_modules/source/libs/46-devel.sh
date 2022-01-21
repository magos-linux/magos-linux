#!/bin/bash
NUM="46"
NAME="devel"
. ../functions || exit 1

clean

prepare

mkdir -p rootfs/var/lib/rpm/modules cache
dnf -y --downloadonly --destdir cache install gcc-c++ debugedit dwz elfutils flex glib-gettextize git python3-markdown\
  dkms rpm-build rpmtools rpm-manbo-setup-build rpm-mandriva-setup-build devel-rpm-generators cmake-rpm-generators efi-srpm-macros\
  lib64elfutils-devel lib64dbus-1-devel lib64devmapper-event-devel lib64glib2.0-devel lib64kmod-devel lib64ncurses-devel lib64packagekit-devel lib64udev-devel lib64nss-devel || exit 1
rsync -a --delete cache/ $CACHE || exit 1

cd rootfs
for a in $CACHE/*.rpm ;do
   rpm2cpio $a | cpio -i -d 2>/dev/null || exit 1
done
ls -1 $CACHE/*.rpm | sed 's|.*/||' > var/lib/rpm/modules/$NUM-$NAME
cd ../

pack rootfs $(dirname $DIRNAME)/$NUM-$NAME

clean
