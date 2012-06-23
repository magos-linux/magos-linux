#!/bin/bash
NUM=36
NAME=xbmc
VERSION=11.0_1.pvr.1
RELEASE=$(date +%Y%m%d)
DISTR=2011
AUTHOR=mikhailz
SOURCE0=ftp://mirror.yandex.ru/mandriva/official/2011/i586/media/contrib/backports/xbmc-11.0-1.pvr.1-mdv2011.0.i586.rpm
SOURCE1=http://seppius-xbmc-repo.googlecode.com/files/repository.seppius.zip
DOWNLOADER=wget

. ../functions || exit 1

clean

prepare
mkdir -p rootfs/var/lib/rpm/modules || exit 1

download $SOURCE0
download $SOURCE1

unpack ${SOURCE0##*/} rootfs
unpack ${SOURCE1##*/} ./

move guisettings.xml    rootfs/etc/skel/.xbmc/userdata
move sources.xml        rootfs/etc/skel/.xbmc/userdata
move desktop            rootfs/etc/sysconfig
move autologin          rootfs/etc/sysconfig
move mountemall.rules   rootfs/etc/udev/rules.d
move pmount-hal-user    rootfs/usr/lib/magos/scripts
move repository.seppius rootfs/usr/share/xbmc/addons
move 20-xbmc.pkla       rootfs/var/lib/polkit-1/localauthority/50-local.d

checkrights rootfs

echo "$DIRNAME"

pack rootfs "$DIRNAME"

clean
