#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-beauty
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Farsun http://wiki.alioth.net/index.php/All_OXPs_by_Category "Farsun1.03.zip" "farsun1.03/farsun.oxp" "farsun1.03/farsun_readme.txt"
addmod Griffs_Explosion_Debris http://wiki.alioth.net/index.php/Griff_Industries "Griff_Debris_no_normalmap.zip" "Griff_Debris_no_normalmap/Griff_Debris_sets135_no_normal_map.oxp" "Griff_Debris_no_normalmap/readme.txt"
addmod Griffs_Normalmapped_Ships http://wiki.alioth.net/index.php/Griff_Industries "griff_shipset_all_in_1_v1.2.21.zip" "griff_shipset_all_in_1/griff_shipset_all_in_1.oxp" "griff_shipset_all_in_1/readme.txt"
addmod Griff_Boa http://wiki.alioth.net/index.php/Griff_Boa "Griff Boa.zip" "griff_prototype_boa_normalmapped/griff_boa_prototype_normalmapped.oxp" "griff_prototype_boa_normalmapped/griff_prototype_boa_normalmapped_readme.txt"
addmod Halssis http://wiki.alioth.net/index.php/Halsis "Halsis.zip" "halsis/halsis.oxp" "halsis/README.txt"
addmod Icesteroids http://wiki.alioth.net/index.php/Icesteroids "Ice-asteroidsV2.1.oxp.rar" "Ice-asteroidsV2.1.oxp" "Readme.txt"
addmod Snoopers http://wiki.alioth.net/index.php/Snoopers "Snoopers2.2.1.zip" "Snoopers2.2.1.oxp" "Snoopers2.2.1 Readme.rtf"
addmod System_Redux http://wiki.alioth.net/index.php/System_Redux_%28Oolite%29 "system_redux.zip" "System_Redux.oxp" "System_Redux.oxp/system_redux.txt"
addmod BGS http://wiki.alioth.net/index.php/BGS "BGS-A1.4.zip" "BGS-A1.4.oxp" "BGS-A1.4 Readme.rtf"
addmod Halsis_BGS http://wiki.alioth.net/index.php/BGS "Halsis_BGS.zip" "Halsis_BGS.oxp" "Halsis_BGS Readme.rtf"

cantdownload "http://wiki.alioth.net/index.php/System_Redux_%28Oolite%29" "Update_SystemRedux1.2.3.zip"
unpack "Update_SystemRedux1.2.3.zip" tmp_updSR
mv -f "tmp_updSR/Config"/* "rootfs/opt/Oolite/AddOns/System_Redux.oxp/Config" || exit 1

# patch on 1.76 version. It provides Griffs_Explosion_Debris effect for all standart ships.
move shipdata.plist rootfs/opt/Oolite/oolite.app/Resources/Config

defaultrights rootfs

pack rootfs $DIRNAME

clean
