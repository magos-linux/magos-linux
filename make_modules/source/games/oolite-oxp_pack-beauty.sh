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

#Obsoletes
#obsolete - addmod Farsun http://wiki.alioth.net/index.php/All_OXPs_by_Category "Farsun1.03.zip" "farsun1.03/farsun.oxp" "farsun1.03/farsun_readme.txt"
#replaced by Griffs_Shipset* Griffs_station_bundle - addmod Griffs_Normalmapped_Ships http://wiki.alioth.net/index.php/Griff_Industries "griff_shipset_all_in_1_v1.2.21.zip" "griff_shipset_all_in_1/griff_shipset_all_in_1.oxp" "griff_shipset_all_in_1/readme.txt"
#replaced by Griff_alloys_and_wreckage - addmod Griffs_Explosion_Debris http://wiki.alioth.net/index.php/Griff_Industries "Griff_Debris_no_normalmap.zip" "Griff_Debris_no_normalmap/Griff_Debris_sets135_no_normal_map.oxp" "Griff_Debris_no_normalmap/readme.txt"
#replaced by Hawksound - addmod Halssis http://wiki.alioth.net/index.php/Halsis "Halsis.zip" "halsis/halsis.oxp" "halsis/README.txt"
#replaced by Hawksound - addmod Halsis_BGS http://wiki.alioth.net/index.php/BGS "Halsis_BGS.zip" "Halsis_BGS.oxp" "Halsis_BGS Readme.rtf"
# patch on 1.76 version. It provides Griffs_Explosion_Debris effect for all standart ships.
#move shipdata.plist rootfs/opt/Oolite/oolite.app/Resources/Config

#addmod Name URL archive_name folder_name readme_name
addmod CustomShields http://aegidian.org/bb/viewtopic.php?f=4&t=12507 "CustomShieldsv083.zip" "CustomShieldsv083/CustomShieldsv083.oxp" "CustomShieldsv083/CustomShieldsv0.83 Readme.txt"
addmod BGS http://wiki.alioth.net/index.php/BGS "BGS-A1.6.zip" "BGS-A1.6.oxp" "BGS-A1.6 Readme.rtf"
addmod Griffs_Shipset_resources http://wiki.alioth.net/index.php/Griff_Industries "Griff_Shipset_Resources_v1.2.25.zip" "Griff_Shipset_Resources_v1.2.25/Griff_Shipset_Resources_v1.2.25.oxp" "Griff_Shipset_Resources_v1.2.25/readme.txt"
addmod Griffs_Shipset http://wiki.alioth.net/index.php/Griff_Industries "Griff_Shipset_Replace_v1.34.zip" "Griff_Shipset_Replace_v1.34/Griff_Shipset_Replace_v1.34.oxp" "Griff_Shipset_Replace_v1.34/readme.txt"
#addmod Griffs_Shipset http://wiki.alioth.net/index.php/Griff_Industries "Griff_Shipset_Addition_v1.22.zip" "Griff_Shipset_Addition_v1.22/Griff_Shipset_Addition_v1.22.oxp" "Griff_Shipset_Addition_v1.22/readme.txt"
addmod Griffs_station_bundle http://wiki.alioth.net/index.php/Griff_Industries "griff_station_bundle_fullsize_tex_v1.1.zip" "griff_station_bundle_fullsize_tex_v1.1/griff_station_bundle_fullsize_tex_v1.1.oxp" "griff_station_bundle_fullsize_tex_v1.1/readme.txt"
addmod Griff_Boa http://wiki.alioth.net/index.php/Griff_Boa "Griff Boa.zip" "griff_prototype_boa_normalmapped/griff_boa_prototype_normalmapped.oxp" "griff_prototype_boa_normalmapped/griff_prototype_boa_normalmapped_readme.txt"
addmod Griff_alloys_and_wreckage http://wiki.alioth.net/index.php/Griff_Industries "Griff_alloys_and_wreckage.zip" "Griff_alloys_and_wreckage/griff_alloys_and_wreckage.oxp" "Griff_alloys_and_wreckage/readme.txt"
addmod Hawksound http://wiki.alioth.net/index.php/Hawksound "Hawksound.zip" "Hawksound.oxp" ""
addmod Hawksound_BGS http://wiki.alioth.net/index.php/Hawksound "Hawksound_BGS1.1.zip" "Hawksound_BGS1.1.oxp" "Hawksound_BGS1.1 Readme.rtf"
addmod Icesteroids http://wiki.alioth.net/index.php/Icesteroids "Ice-asteroidsV2.1.oxp.rar" "Ice-asteroidsV2.1.oxp" "Readme.txt"
addmod Snoopers http://wiki.alioth.net/index.php/Snoopers "Snoopers2.4.zip" "Snoopers2.4.oxp" "Snoopers2.4 Readme.rtf"
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean
