#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-planets_FP
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Famous_Planets http://wiki.alioth.net/index.php/Famous_Planets_OXP "Famous Planets v2.5.zip" "Famous Planets v2.5/Famous_Planets_v2.5.oxp" "Famous Planets v2.5/Famous Planets v2.5Manual.pdf"
cantdownload "http://wiki.alioth.net/index.php/Famous_Planets_OXP" "Update_FamousPlanets2.5.1.zip"
unpack "Update_FamousPlanets2.5.1.zip" tmp_updFP
mv -f "tmp_updFP/Update_FamousPlanets2.5.1/Config"/* "rootfs/opt/Oolite/AddOns/Famous_Planets.oxp/Config" || exit 1
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean
