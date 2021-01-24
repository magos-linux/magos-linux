#!/bin/bash
NUM=81
NAME=virtualbox-plugin
RELEASE=$(date +%Y%m%d)
DISTR=2016
AUTHOR=dont_redistribute
VERSION=$(rpm -qq virtualbox | awk -F- '{print $2}')

SOURCE0=https://download.virtualbox.org/virtualbox/${VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VERSION}.vbox-extpack
#DOWNLOADER="wget --proxy=192.168.42.129:8080"
DOWNLOADER=wget

. ../functions || exit 1

clean

prepare

download $SOURCE0

mv -f ${SOURCE0##*/} ${SOURCE0##*/}.tar.gz
mkdir -p "rootfs/usr/lib64/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack"
unpack ${SOURCE0##*/}.tar.gz "rootfs/usr/lib64/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack"

defaultrights rootfs

echo "$DIRNAME"

pack rootfs "$DIRNAME"

clean
