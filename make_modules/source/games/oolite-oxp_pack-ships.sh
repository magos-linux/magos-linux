#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-ships
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
#broken addmod ADCKs_Behemoths http://wiki.alioth.net/index.php/ADCK%27s_Behemoths "adcks_behemoths_v1.2.oxp.zip" "adcks_behemoths_v1.2.oxp" "adcks_behemoths_v1.2.oxp/Readme_v1.2.txt"
#addmod Aphid_Escort_Service http://oosat.alioth.net/files/aphidv2.oxp_.zip "aphidv2.oxp_.zip" "aphidv2.oxp" ""

addmod ADCKs_Eagles http://wiki.alioth.net/index.php/Eagle_Mk_II "Eagle2.zip" "eagle2.oxp" "eagle2.oxp/readme.txt"
addmod Aegidians_Specials http://wiki.alioth.net/index.php/Aegidian%27s_Specials "aegidian-special 1.2.zip" "aegidian-special 1.2/aegidian-special.oxp" "aegidian-special 1.2/ReadMe.rtf"
addmod Aegidians_X-Ships http://wiki.alioth.net/index.php/Aegidian%27s_X-Ships "aegidian_x_ships11.zip" "aegidian x-ships 1.1/x-ships.oxp" "aegidian x-ships 1.1/ReadMe.rtf"
addmod Aquatics http://wiki.alioth.net/index.php/Aquatics_OXP "aquatics_2.29.zip" "Aquatics 2.29.oxp" "Aquatics v2.29 Readme & License.txt"
addmod Armoured_Transport_Type_1 http://wiki.alioth.net/index.php/Armoured_Transport_Type_1 "att1.zip" "att1/att1.oxp" "att1/readme.rtf"
addmod Aurora http://wiki.alioth.net/index.php/Aurora "pagroove_Aurorav1.1.oxp.zip" "pagroove_Aurorav1.1.oxp" "pagroove_Aurorav1.1.oxp/Readmev1.1txt.txt"
addmod Baakili_Far_Trader http://wiki.alioth.net/index.php/Baakili_Far_Trader "Baakili Far Trader 2.0.zip" "Baakili_Far_Trader_v2.0.oxp" "Baakili Far Trader 2.0  ReadMe.txt"
addmod Bandersnatch http://capnhack.com/hosting/oolite/dropbox/bandersnatch_1_1.zip "bandersnatch_1_1.zip" "bandersnatch 1.1/bandersnatch.oxp" "bandersnatch 1.1/Readme.txt"
addmod Behemoth http://wiki.alioth.net/index.php/Behemoth "behemoth_2_6.zip" "behemoth 2.6/behemoth 2.6.oxp" "behemoth 2.6/Behemoth.readMe.rtf"
addmod Behemoth_Space-war http://wiki.alioth.net/index.php/Behemoth_Spacewar "BehemothSpacewar 1.3.zip" "BehemothSpacewar 1.3/BehemothSpacewar 1.3.oxp" "BehemothSpacewar 1.3/BehemothSpacewar.readme.rtf"
addmod Boomslang http://wiki.alioth.net/index.php/Boomslang "BoomSlang2.zip" "BoomSlang2/boomslang.oxp" "BoomSlang2/readme.txt"
addmod BigShips http://wiki.alioth.net/index.php/BigShips_OXP "bigships_1.02.zip" "BigShips 1.02.oxp" "BigShips v1.02 Readme & License.txt"
addmod Bulk_Haulers http://wiki.alioth.net/index.php/Bulk_Haulers "adcks_bulk_haulers_v1.4.oxp.zip" "adcks_bulk_haulers_v1.4.oxp" "adcks_bulk_haulers_v1.4.oxp/Readme_v1.4.txt"
addmod Caduceu http://wiki.alioth.net/index.php/Caduceus "neoCaduceus_141210.zip" "neoCaduceus_141210/neocaduceus.oxp" "neoCaduceus_141210/readme.txt"
addmod Cobra_Clipper_SAR http://wiki.alioth.net/index.php/Cobra_Clipper_SAR "cobraClipper 1.1.1.zip" "cobraClipper 1.1.1/cobraClipper 1.1.1.oxp" "cobraClipper 1.1.1/CobraClipper ReadMe.rtf"
addmod Chopped_Cobra http://wiki.alioth.net/index.php/Chopped_Cobra "Staer9Cobra.zip" "Staer9Cobra/staer9_chopped_cobraV1.1.1.oxp" "Staer9Cobra/readme.txt"
addmod Deep_Space_Dredger http://wiki.alioth.net/index.php/Deep_Space_Dredger "Dredgers 2.4.6.zip" "Dredgers 2.4.6/Dredgers 2.4.6.oxp" "Dredgers 2.4.6/Deep Space Dredger ReadMe.rtf"
addmod Dragon http://wiki.alioth.net/index.php/Dragon "Dragon 1.72.2.zip" "Dragon 1.72.2/dragon.oxp" "Dragon 1.72.2/Dragon 1.72 .2 ReadMe.txt"
addmod Far_Star_Murderer http://wiki.alioth.net/index.php/Far_Star_Murderer "FarstarMurderer1.1.zip" "FarstarMurderer1.1.oxp" "FarstarMurderer1.1 Readme.rtf"
addmod Flying_Dutchman http://wiki.alioth.net/index.php/Flying_Dutchman_OXP "FlyingDutchman1.7.zip" "FlyingDutchman1.7/flying_Dutchman.oxp" "FlyingDutchman1.7/readMe.rtf"
addmod Generation_Ships http://wiki.alioth.net/index.php/Generation_Ships_OXP "Generation Ships 1.3.zip" "Generation Ships 1.3/Generation Ships.oxp" "Generation Ships 1.3/readMe.rtf"
addmod Griff_Krait http://wiki.alioth.net/index.php/Griff_Krait "griff_krait_v1.1.zip" "griff_krait_v1.1/griff_krait_v1.1.oxp" "griff_krait_v1.1/griff_krait_v1.1_readme.txt"
addmod Hognose_Tugships http://wiki.alioth.net/index.php/Hognose "tugs.zip" "tugs/tugs.oxp" "tugs/readme.rtf"
addmod Jabberwocky http://wiki.alioth.net/index.php/Jabberwocky "jabberwocky.zip" "jabberwocky.oxp" ""
addmod Kestrel_and_Falcon http://wiki.alioth.net/index.php/Kestrel_%26_Falcon_OXP "kestrel_falcon1_71_0.zip" "kestrel&falcon1.71.0/Kestrel&Falcon.oxp" "kestrel&falcon1.71.0/Kestrel&Falcon_ReadMe.txt"
addmod Llama http://wiki.alioth.net/index.php/Llama "Llama.zip" "Llama/Llama.oxp" "Llama/readme.rtf"
#addmod Ramons_Anaconda http://wiki.alioth.net/index.php/Ramon%27s_Anaconda "" "" ""
addmod Python_Class_Cruiser http://wiki.alioth.net/index.php/Python_Class_Cruiser "Python_Class_Cruiser.oxp.zip" "Python Class Cruiser 2.6.oxp" ""
addmod Thargorn_Threat http://wiki.alioth.net/index.php/Thargorn_Threat_oxp "Thargorn_Threat 1.5.2.zip" "Thargorn_Threat 1.5.2/Thargorn_Threat 1.5.2.oxp" "Thargorn_Threat 1.5.2/readme_thargorn.txt"
addmod Total_patrol http://wiki.alioth.net/index.php/Total_patrol_OXP "total_patrol 1.4.zip" "total_patrol 1.4/total_patrol.oxp" "total_patrol 1.4/readMe.rtf"
addmod Transports http://wiki.alioth.net/index.php/Transports "Transports 2.52.zip" "Transports 2.52/Transports 2.52.oxp" "Transports 2.52/transports_readme.txt"
addmod Vortex http://wiki.alioth.net/index.php/Vortex_OXP "vortex_1.27.zip" "Vortex 1.27.oxp" "Vortex v1.27 Readme & License.txt"
addmod Wormhole_restoration http://wiki.alioth.net/index.php/Wormhole_restoration_OXP "wormhole_restoration 1.1.zip" "wormhole_restoration 1.1/wormhole_restoration.oxp" "wormhole_restoration 1.1/readMe.rtf"
addmod Executive_SpaceWays http://wiki.alioth.net/index.php/Executive_SpaceWays "Executive SpaceWays v2.4.zip" "Executive SpaceWays v2.4/Executive Spaceways v2.4.oxp" "Executive SpaceWays v2.4/Readme.txt"
addmod Saleza_Aeronuatics http://www.arcadia-digital.net/steve/Oolite/Oolite.html "Saleza Aeronautics v2.3.zip" "Saleza Aeronautics v2.3/Saleza v2.3.oxp" "Saleza Aeronautics v2.3/Readme.txt" 
echo

rm -f rootfs/opt/Oolite/AddOns/Griff_Krait.oxp/Config/script.js

defaultrights rootfs

nopack rootfs $DIRNAME

clean
