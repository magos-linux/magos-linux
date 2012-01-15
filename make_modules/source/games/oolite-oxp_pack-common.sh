#!/bin/bash
NUM=71
NAME=oolite-oxp_pack-common
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Cabal_Common_Library http://wiki.alioth.net/index.php/Cabal_Common_Library "Cabal_Common_Library1.5.zip" "Cabal_Common_Library1.5.oxp" "Cabal_Common_Library1.5 Readme.rtf"

defaultrights rootfs

pack rootfs $DIRNAME

clean
