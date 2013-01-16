#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-planets_SR
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod System_Redux http://wiki.alioth.net/index.php/System_Redux_%28Oolite%29 "system_redux.zip" "System_Redux.oxp" "System_Redux.oxp/system_redux.txt"
cantdownload "http://wiki.alioth.net/index.php/System_Redux_%28Oolite%29" "Update_SystemRedux1.2.3.zip"
unpack "Update_SystemRedux1.2.3.zip" "tmp_updSR"
mv -f "tmp_updSR/Config"/* "rootfs/opt/Oolite/AddOns/System_Redux.oxp/Config" || exit 1
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean


