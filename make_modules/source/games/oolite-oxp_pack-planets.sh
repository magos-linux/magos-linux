#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-planets
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Diso http://wiki.alioth.net/index.php/Diso_OXP "Diso.zip" "Diso/Diso.oxp" ""
addmod Famous_Planets http://wiki.alioth.net/index.php/Famous_Planets_OXP "Famous Planets v2.5.zip" "Famous Planets v2.5/Famous_Planets_v2.5.oxp" "Famous Planets v2.5/Famous Planets v2.5Manual.pdf"
addmod Lave http://wiki.alioth.net/index.php/Lave_OXP "Lave171.zip" "Lave 1.71/Lave.oxp" "Lave 1.71/lave_readme.txt"
addmod Tianve http://wiki.alioth.net/index.php/Tianve "Tianve1.3.zip" "Tianve1.3.oxp" "ReadMe.rtf"
addmod Tionisla_Orbital_Graveyard http://wiki.alioth.net/index.php/Tionisla_Orbital_Graveyard "TOGY 1.1.zip" "TOGY 1.1/TOGY_Main 1.1.oxp" "TOGY 1.1/ReadMe.txt"

cantdownload "http://wiki.alioth.net/index.php/Famous_Planets_OXP" "Update_FamousPlanets2.5.1.zip"
unpack "Update_FamousPlanets2.5.1.zip" tmp_updFP
mv -f "tmp_updFP/Update_FamousPlanets2.5.1/Config"/* "rootfs/opt/Oolite/AddOns/Famous_Planets.oxp/Config" || exit 1

defaultrights rootfs

pack rootfs $DIRNAME

clean
