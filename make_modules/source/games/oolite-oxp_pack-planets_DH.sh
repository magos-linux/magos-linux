#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-planets_DH
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Deep_Horizons-Lights_Down http://deephorizonindustries.com/Lights_Down.html "Deep_Horizons-Lights_Down.zip" "Deep_Horizons-Lights_Down/Deep Horizons - Lights Down/Deep Horizons - Lights Down.oxp" "Deep_Horizons-Lights_Down/Deep Horizons - Lights Down/License.txt"
addmod Deep_Horizons http://deephorizonindustries.com/default.html "Deep_Horizons-Systems.zip" "Deep_Horizons-Systems/Deep Horizons - Systems/Deep Horizons - Systems.oxp" "Deep_Horizons-Systems/Deep Horizons - Systems/License.txt"
cantdownload "http://deephorizonindustries.com/File_Download.aspx?type=0&quality=99&target=Standard_Resolution_Texture_Pack" "Standard_Resolution_Texture_Pack.zip"
unpack "Standard_Resolution_Texture_Pack.zip" "./"
mv -v "Standard_Resolution_Texture_Pack/Standard Resolution Texture Pack/Textures" "rootfs/opt/Oolite/AddOns/Deep_Horizons.oxp" || exit 1
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean


