#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-equipment
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Armoury http://wiki.alioth.net/index.php/Armoury_OXP "armoury_1.11.zip" "Armoury 1.11.oxp" "Armoury 1.11 Readme & License.txt"
addmod Auto_eject http://wiki.alioth.net/index.php/Auto_eject_OXP "auto_eject 1.0.zip" "auto_eject 1.0/auto_eject.oxp" "auto_eject 1.0/readMe.rtf"
addmod Missile_Spoof http://wiki.alioth.net/index.php/Automatic_Chaff_System "missile_spoof.zip" "missile_spoof.oxp" ""
addmod Bounty_Scanner http://wiki.alioth.net/index.php/Bounty_Scanner "BountyScannerv2.0.oxp.rar" "BountyScannerv2.0.oxp" ""
addmod BountyStatus http://wiki.alioth.net/index.php/BountyStatus_OXP "bountyStatus_1.00.zip" "BountyStatus 1.00.oxp" "Bounty Status v1.00 Readme.txt"
addmod Cargo_Wreck_Teaser http://wiki.alioth.net/index.php/Cargo_Wreck_Teaser_OXP "Cargo_wrecks_teaser 1.7.1.zip" "Cargo_wrecks_teaser 1.7.1/Cargo_wrecks_teaser 1.7.1.oxp" "Cargo_wrecks_teaser 1.7.1/readmeifyouplease_wrex.txt"
addmod CloakRepair http://aegidian.org/bb/viewtopic.php?f=4&t=11678 "CloakRepair.zip" "CloakRepair/CloakRepair.oxp" "CloakRepair/readme.rtf"
addmod Display_reputation http://wiki.alioth.net/index.php/Display_reputation_OXP "display_reputation 1.1.zip" "display_reputation 1.1/display_reputation.oxp" "display_reputation 1.1/readMe.rtf"
# incompatible with 1.77 - addmod Docking_Clearance_Protocol http://wiki.alioth.net/index.php/Oolite_Docking_Clearance_Protocol_%28v1.72_or_later%29 "Docking Clearance 1.1.zip" "Docking Clearance 1.1/Docking Clearance 1.1.oxp" "Docking Clearance 1.1/Docking Clearance ReadMe.rtf"
addmod Escape_Pod_Locator http://wiki.alioth.net/index.php/Escape_Pod_Locator_OXP "Escape_Capsule_Locator_1.4.1_2012-06-05.zip" "Escape_Capsule_Locator_1.4.1_2012-06-05.oxp" "readme.rtf"
addmod ETT_Homing_Beacon http://wiki.alioth.net/index.php/ETT_Homing_Beacon "ettBeaconLauncher 1.02 (1).zip" "ettBeaconLauncher 1.02/ettBeaconLauncher 1.02.oxp" "ettBeaconLauncher 1.02/ettBeaconLauncher Readme & License.txt"
addmod ExtraFuelTanks http://wiki.alioth.net/index.php/ExtraFuelTanks "ExtraFuelTanks.zip" "ExtraFuelTanks/ExtraFuelTanksV1 .4.1.oxp" "ExtraFuelTanks/readme.rtf"
addmod Fuel_Collector http://wiki.alioth.net/index.php/Fuel_Collector_OXP "FuelCollectorV0.07.zip" "FuelCollectorV0.07/FuelCollectorV0.07.oxp" "FuelCollectorV0.07/Fuelcollector.txt"
addmod Fuel_Tank http://www.arcadia-digital.net/steve/Oolite/Equipment/Fuel%20Tank%20v2.2.zip "Fuel Tank v2.2.zip" "Fuel Tank v2.2/Fuel Tank v2.2.oxp" "Fuel Tank v2.2/Readme.txt"
addmod Galaxy_Info http://wiki.alioth.net/index.php/OXP_List "GalaxyInfo V1.1.0.zip" "GalaxyInfo V1.1.0/GalaxyInfo.oxp" "GalaxyInfo V1.1.0/GalaxyInfo.txt"
addmod Misjump_Analyser http://wiki.alioth.net/index.php/Misjump_Analyser "Misjump Analyser 1.1.zip" "Misjump Analyser 1.1/Misjump Analyser 1.1.oxp" "Misjump Analyser 1.1/Witchspace Analyser readMe.rtf"
addmod Missile_Analyser http://wiki.alioth.net/index.php/Missile_Analyser "Missile Analyser 1.2.zip" "Missile Analyser 1.2/Missile Analyser 1.2.oxp" "Missile Analyser 1.2/Missile Analyser readMe.rtf"
addmod Missiles_and_Bombs http://wiki.alioth.net/index.php/Missiles_and_Bombs "Missiles and Bombs v2.5.zip" "Missiles and Bombs v2.5.oxp" "Missiles and Bombs v2.5.oxp/Missiles and Bombs v2.5.rtf"
addmod Ore_Processor http://wiki.alioth.net/index.php/Ore_Processor "Ore_processor 1.59.zip" "Ore_processor 1.59/Ore_processor 1.59.oxp" "Ore_processor 1.59/ReadMe.txt"
addmod Police_IFF_Scanner_Upgrade http://wiki.alioth.net/index.php/Police_IFF_Scanner_Upgrade "Police_Scanner_Upgrade_1.3.1_2011-12-18.zip" "Police_Scanner_Upgrade_1.3.1_2011-12-18.oxp" "readme.rtf"
addmod Pylon_Based_Equipment_Remover http://wiki.alioth.net/index.php/OXP_List "PylonBasedEqRemover v.0.8.zip" "PylonBasedEqRemover v.0.8/PylonBasedEqRemover v0.8.oxp" "PylonBasedEqRemover v.0.8/ReadMe.txt"
addmod Rock_Hermit_Locator http://wiki.alioth.net/index.php/Rock_Hermit_Locator "Rock_Hermit_Locator1.3.3.zip" "Rock_Hermit_Locator1.3.3/Rock_Hermit_Locator1.3.3.oxp" "Rock_Hermit_Locator1.3.3/Rock Hermit Locator ReadMe.rtf"
addmod SniperLock http://wiki.alioth.net/index.php/SniperLock "SniperLockv1.zip" "SniperLockv1/SniperLockv1.oxp" "SniperLockv1/SniperLockv1 Readme.txt"
addmod Status_Quo_Q-bomb http://wiki.alioth.net/index.php/Status_Quo_Q-bomb_OXP "Status_Quo_Q-bomb 1.3.zip" "Status_Quo_Q-bomb 1.3/Status_Quo_Q-bomb.oxp" "Status_Quo_Q-bomb 1.3/readMe.rtf"
addmod Tracker http://wiki.alioth.net/index.php/Tracker_OXP "tracker_1.02.zip" "Tracker 1.02.oxp" "Tracker v1.02 ReadMe & License.txt"
#addmod Sniper_Sight http://wiki.alioth.net/index.php/Sniper_Scope_%26_Sniper_Sight ""
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean
