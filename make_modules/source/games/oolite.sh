#!/bin/bash
NUM=41
NAME=oolite
VERSION=1.77
RELEASE=$(date +%Y%m%d)
DISTR=2011
AUTHOR=
SOURCE0=http://prdownload.berlios.de/oolite-linux/oolite-1.77.linux-x86.tgz
SOURCE1=http://roolite.org/manual.zip
PATCH0=oolite-desktop.patch

. ../functions || exit 1

clean

prepare
mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc rootfs/opt/Oolite/oolite-deps rootfs/opt/Oolite/oolite.app || exit 1

download $SOURCE0
download $SOURCE1

unpack ${SOURCE0##*/} ./
unpack ${SOURCE1##*/} ./
unpack oolite-$VERSION.linux-x86.run ./ --noexec --target ./tmp
#unpack tmp/oolite.installer.tmp/addons.tar.gz rootfs/opt/Oolite
unpack tmp/oolite.installer.tmp/freedesktop.tar.gz tmp
unpack tmp/oolite.installer.tmp/oolite.deps.tar.gz rootfs/opt/Oolite/oolite-deps
unpack tmp/oolite.installer.tmp/oolite.doc.tar.gz rootfs/opt/Oolite/doc
unpack tmp/oolite.installer.tmp/oolite.dtd.tar.gz rootfs/opt/Oolite/oolite-deps
unpack tmp/oolite.installer.tmp/oolite.wrap.tar.gz tmp

move tmp/FreeDesktop/oolite-icon.png rootfs/usr/share/pixmaps
move tmp/oolite.installer.tmp/release.txt rootfs/opt/Oolite
move tmp/oolite rootfs/opt/Oolite/oolite.app
move tmp/Resources rootfs/opt/Oolite/oolite.app
moveas tmp/oolite.src rootfs/opt/Oolite/oolite.app/oolite-wrapper
moveas Oolite_manual_*.doc rootfs/opt/Oolite/doc/Oolite_manual_ru.doc

applypatch rootfs $PATCH0

checkrights rootfs

pack rootfs $DIRNAME

clean
