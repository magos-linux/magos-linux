#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-planets_povray5
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns

#addmod Name URL archive_name folder_name readme_name
addmod Povray_Planets http://wiki.alioth.net/index.php/PovrayPlanets_OXP "Povray_Planets_v1.0_2012-02-05.zip" "Povray_Planets_v1.0_2012-02-05/Povray_Planets_1.0.oxp" ""
addmod Povray_G5 http://wiki.alioth.net/index.php/PovrayPlanets_OXP "Povray_Planets_Galaxy5_Textures_v1.0_2012-02-28.zip" "Povray_Planets_Galaxy5_Textures_v1.0_2012-02-28/Povray_Planets_Galaxy5_Textures.oxp" ""
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean
