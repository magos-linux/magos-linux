#!/bin/bash
NUM=36
NAME=xbmc
VERSION=12.2-2
RELEASE=$(date +%Y%m%d)
DISTR=2012
AUTHOR=mikhailz
SOURCE0=http://magos.sibsau.ru/repository/rpms/2012/xbmc-12.2-2-rosa2012.1.i586.rpm
#SOURCE0=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/i586/contrib/updates/xbmc-12.1-2-rosa2012.1.i586.rpm
SOURCE1=http://seppius-xbmc-repo.googlecode.com/files/repository.seppius.zip
SOURCE2=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/i586/contrib/updates/slim-1.3.4-11-rosa2012.1.i586.rpm
DOWNLOADER=wget

#DISTR=2012lts
#VERSION=11.0_1.pvr.2
#SOURCE0=http://mirror.rosalinux.com/rosa/rosa2012lts/repository/i586/contrib/updates/xbmc-11.0-1.pvr.2-rosa.lts2012.0.i586.rpm

. ../functions || exit 1

clean

prepare
mkdir -p rootfs/var/lib/rpm/modules || exit 1

download $SOURCE0
download $SOURCE1
download $SOURCE2

unpack ${SOURCE0##*/} rootfs
unpack ${SOURCE1##*/} ./
unpack ${SOURCE2##*/} rootfs
unpack xbmc.tar.gz ./

move .xbmc              rootfs/etc/skel
move desktop            rootfs/etc/sysconfig
move slim.conf          rootfs/etc
move mountemall.rules   rootfs/etc/udev/rules.d
move pmount-hal-user    rootfs/usr/lib/magos/scripts
move repository.seppius rootfs/usr/share/xbmc/addons
move 20-xbmc.pkla       rootfs/var/lib/polkit-1/localauthority/50-local.d

checkrights rootfs

echo "$DIRNAME"

pack rootfs "$DIRNAME"

clean
