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
addmod OXPConfig http://wiki.alioth.net/index.php/OXPConfig "OXPConfig2.2.4.zip" "OXPConfig2.2.4.oxp" "OXPConfig2.2.4 Readme.rtf"
addmod Cabal_Common_Library http://wiki.alioth.net/index.php/Cabal_Common_Library "Cabal_Common_Library1.7.zip" "Cabal_Common_Library1.7.oxp" "Cabal_Common_Library1.7 Readme.rtf"
echo

defaultrights rootfs

pack rootfs $DIRNAME

clean
