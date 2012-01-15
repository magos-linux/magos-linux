#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-missions
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Asteroid_Storm http://wiki.alioth.net/index.php/Asteroid_Storm "AsteroidStorm 4.02.zip" "AsteroidStorm 4.02/AsteroidStorm 4.02.oxp" "AsteroidStorm 4.02/asteroidstorm_readme.txt"
addmod BlackjacksBullion http://wiki.alioth.net/index.php/BlackjacksBullion_OXP "Blackjacksbullion js v1.25.oxp.tar.gz" "Blackjacksbullion js v1.25.oxp" ""
addmod Deposed http://wiki.alioth.net/index.php/Deposed_OXP "Deposed 1.3.4.zip" "Deposed 1.3.4/Deposed1.3.4.oxp" "Deposed 1.3.4/README.txt"
addmod Ionics http://wiki.alioth.net/index.php/Ionics_OXP "ionics-1.3.1.zip" "ionics-1.3.1/ionics-1.3.1.oxp" "ionics-1.3.1/readme.txt"
addmod Long_Way http://wiki.alioth.net/index.php/LongWay_OXP "longway_11.zip" "longway 1.1.oxp" "longway 1.1.oxp/readme.txt"
addmod Military_Fiasco http://wiki.alioth.net/index.php/Military_Fiasco "military Fiasco 2.5.2.zip" "military Fiasco 2.5.2/military Fiasco 2.5.2.oxp" "military Fiasco 2.5.2/Military Fiasco readme.rtf"
addmod Spy_Hunter http://wiki.alioth.net/index.php/Spy_Hunter_OXP "Spyhunter_1_1.zip" "Spyhunter_1_1/spyhunter 1.1.oxp" "Spyhunter_1_1/spyhunter 1.1.oxp/readme.txt"
addmod Stealth http://wiki.alioth.net/index.php/Stealth_OXP "stealth_1.04.zip" "Stealth 1.04.oxp" "Stealth 1.04 Readme & License.txt"
addmod Taranis http://wiki.alioth.net/index.php/Taranis_OXP "Taranis_1_2.zip" "Taranis 1.2/Taranis 1.2.oxp" "Taranis 1.2/readme.txt"
addmod To_Catch_a_Thargoid http://wiki.alioth.net/index.php/TCAT_OXP "TCAT_1.10.zip" "TCAT 1.10.oxp" "TCAT v1.10 Readme & License.txt"
addmod Trident_Down http://wiki.alioth.net/index.php/Trident_Down "Trident_Down_v2.2.zip" "Trident_Down_v2.2/Trident Down v2.2.oxp" "Trident_Down_v2.2/Trident Down readme.rtf"

defaultrights rootfs

pack rootfs $DIRNAME

clean
