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
addmod Assassins_Guild http://wiki.alioth.net/index.php/The_Assassins_Guild_OXP "AssassinsV1_3_3.zip" "AssassinsV1_3_3/Assassins.oxp" "AssassinsV1_3_3/readme.txt"
addmod Asteroid_Storm http://wiki.alioth.net/index.php/Asteroid_Storm "AsteroidStorm 4.03.zip" "AsteroidStorm 4.03/AsteroidStorm 4.03.oxp" "AsteroidStorm 4.03/asteroidstorm_readme.txt"
addmod BlackjacksBullion http://wiki.alioth.net/index.php/BlackjacksBullion_OXP "Blackjack_Bullion_1.2.9_oxp.zip" "galaxy 2, Blackjack's Bullion 1.2.9.oxp" ""
addmod Coyotes_Run http://wiki.alioth.net/index.php/Coyote%27s_Run "Coyote's Run V1.1.0.zip" "Coyote's Run V1.1.0/Coyote's Run.oxp" "Coyote's Run V1.1.0/Coyote's Run Readme.rtf"
#If Griff shipset installed
addmod Coyotes_Run_Griff http://wiki.alioth.net/index.php/Coyote%27s_Run "Coyote's Run V1.1.0.zip" "Coyote's Run V1.1.0/Coyote's Run For Griff.oxp" "Coyote's Run V1.1.0/Coyote's Run Readme.rtf"
addmod Deposed http://wiki.alioth.net/index.php/Deposed_OXP "Deposed 1.3.4.zip" "Deposed 1.3.4/Deposed1.3.4.oxp" "Deposed 1.3.4/README.txt"
addmod Ionics http://wiki.alioth.net/index.php/Ionics_OXP "ionics-1.3.1.zip" "ionics-1.3.1/ionics-1.3.1.oxp" "ionics-1.3.1/readme.txt"
addmod Iron_Raven http://www.arcadia-digital.net/steve/Oolite/Missions.html "Iron_Raven_v1.2.zip" "Iron_Raven_v1.2/Iron_Raven_v1.2.oxp" "Iron_Raven_v1.2/Iron Raven Brief.pdf"
addmod Long_Way http://wiki.alioth.net/index.php/LongWay_OXP "longway_11.zip" "longway 1.1.oxp" "longway 1.1.oxp/readme.txt"
addmod Lovecats http://wiki.alioth.net/index.php/Lovecats.oxp "lovecats 1.3.0.zip" "lovecats 1.3.0/lovecats 1.3.0.oxp" "lovecats 1.3.0/Lovecats readme.rtf"
addmod Military_Fiasco http://wiki.alioth.net/index.php/Military_Fiasco "military Fiasco 2.5.2.zip" "military Fiasco 2.5.2/military Fiasco 2.5.2.oxp" "military Fiasco 2.5.2/Military Fiasco readme.rtf"
addmod Oo-Haul http://wiki.alioth.net/index.php/Oo-Haul "Oo-Haul_V1.6.zip" "Oo-Haul.oxp" "Read_me.txt"
addmod Resistance_Commander http://www.arcadia-digital.net/steve/Oolite/Missions.html "ResistanceCommander_v1.4.zip" "ResistanceCommander_v1.4/ResistanceCommander_v1.4.oxp" "ResistanceCommander_v1.4/Resistance_Commander.pdf"
addmod Spy_Hunter http://wiki.alioth.net/index.php/Spy_Hunter_OXP "Spyhunter_1_1.zip" "Spyhunter_1_1/spyhunter 1.1.oxp" "Spyhunter_1_1/spyhunter 1.1.oxp/readme.txt"
addmod Stealth http://wiki.alioth.net/index.php/Stealth_OXP "stealth_1.04.zip" "Stealth 1.04.oxp" "Stealth 1.04 Readme & License.txt"
addmod Taranis http://wiki.alioth.net/index.php/Taranis_OXP "Taranis 1.3.zip" "Taranis 1.3/Taranis 1.3.oxp" "Taranis 1.3/readme.txt"
addmod To_Catch_a_Thargoid http://wiki.alioth.net/index.php/TCAT_OXP "TCAT_1.11.zip" "TCAT 1.11.oxp" "TCAT v1.11 Readme & License.txt"
addmod Trident_Down http://wiki.alioth.net/index.php/Trident_Down "Trident_Down_v2.4.zip" "Trident_Down_v2.4/Trident Down v2.4.oxp" "Trident_Down_v2.4/Trident Down readme.rtf"
#addmod Thargoid_War http://wiki.alioth.net/index.php/Thargoid_Wars "thargoid_wars 4.5.4.zip" "thargoid_wars 4.5.4/thargoid_wars 4.5.4.oxp" "thargoid_wars 4.5.4/README.txt"
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean
