#!/bin/bash
NUM=72
NAME=wine-gecko
VERSION=1.5
RELEASE=$(date +%Y%m%d)
DISTR=2011
AUTHOR=mikhailz
SOURCE0=http://downloads.sourceforge.net/wine/wine_gecko-${VERSION}-x86.msi
DOWNLOADER=wget

. ../functions || exit 1

clean

prepare
mkdir -p rootfs/usr/share/wine/gecko || exit 1

download $SOURCE0

move ${SOURCE0##*/} rootfs/usr/share/wine/gecko

checkrights rootfs

echo pack rootfs $DIRNAME
pack rootfs $DIRNAME

clean
