#!/bin/bash
NUM=81
NAME=oolite-oxp_pack-ru
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Oolite_Ru_Pack http://roolite.org/oolite_ru.zip "oolite_ru.zip" "Oolite_Ru_Pack_v.2.7b.oxp" ""
echo

defaultrights rootfs

pack rootfs $DIRNAME

clean
