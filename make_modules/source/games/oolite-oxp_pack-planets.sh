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

addmod Diso http://wiki.alioth.net/index.php/Diso_OXP "Diso.zip" "Diso/Diso.oxp" ""
addmod Lave http://wiki.alioth.net/index.php/Lave_OXP "Lave171.zip" "Lave 1.71/Lave.oxp" "Lave 1.71/lave_readme.txt"
addmod Tianve http://wiki.alioth.net/index.php/Tianve "Tianve1.3.zip" "Tianve1.3.oxp" "ReadMe.rtf"
addmod Tionisla_Orbital_Graveyard http://wiki.alioth.net/index.php/Tionisla_Orbital_Graveyard "TOGY 1.1.zip" "TOGY 1.1/TOGY_Main 1.1.oxp" "TOGY 1.1/ReadMe.txt"
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean


