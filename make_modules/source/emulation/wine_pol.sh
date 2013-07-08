#!/bin/bash
NUM=41-2
NAME=wine
VERSION=1.5.31
RELEASE=$(date +%Y%m%d)
#DISTR=2012
AUTHOR=mikhailz
SOURCE0=http://www.playonlinux.com/wine/binaries/linux-x86/PlayOnLinux-wine-${VERSION}-linux-x86.pol
#DOWNLOADER=wget

. ../functions || exit 1

clean

prepare
mkdir -p rootfs/opt/winebin rootfs/usr/bin tmp || exit 1

download $SOURCE0

mv ${SOURCE0##*/} ${SOURCE0##*/}.tar.gz
unpack ${SOURCE0##*/}.tar.gz tmp

sed -i s/^WINEVER=.*/WINEVER=${VERSION}/ wine
moveas wine rootfs/usr/bin/wine-${VERSION}
move tmp/wineversion/* rootfs/opt/winebin

#checkrights rootfs

pack rootfs $DIRNAME

clean
