#!/bin/bash
NUM=72
NAME=oolite-oxp_pack-world
RELEASE=$(date +%Y%m%d)

. ../functions || exit 1
. oolite-functions || exit 1

clean
prepare

mkdir -p rootfs/opt/Oolite/AddOns rootfs/opt/Oolite/doc/$NAME

move *.txt rootfs/opt/Oolite/doc

#addmod Name URL archive_name folder_name readme_name
addmod Anarchies http://wiki.alioth.net/index.php/Anarchies_OXP "Anarchies v 2.5.zip" "Anarchies v 2.5/Anarchies2.5.oxp" "Anarchies v 2.5/readMe.rtf"
addmod Bank_of_the_Black_Monks http://wiki.alioth.net/index.php/Black_Monk_Monastery "shady blackmonks.zip" "shady blackmonks/Shady_blackmonks.oxp" "shady blackmonks/readme.txt"
addmod BuoyRepair http://wiki.alioth.net/index.php/BuoyRepair "BuoyRepair1.3.1.zip" "BuoyRepair1.3.1.oxp" "BuoyRepair1.3.1 readMe.rtf"
addmod Commies http://wiki.alioth.net/index.php/Commies "Commies 2.11.zip" "Commies 2.11/Commies.oxp" "Commies 2.11/commies.txt"
addmod Dictators http://wiki.alioth.net/index.php/Dictators_OXP "Dictators_v1.5.zip" "Dictators v1.5/Dictators v1.5.oxp" "Dictators v1.5/System Profiles v1.0.pdf"
addmod Factions http://wiki.alioth.net/index.php/Factions_OXP "Factions-1.10.oxp.zip" "Factions-1.10.oxp" "Factions-Readme.txt"
addmod Feudal_States http://wiki.alioth.net/index.php/Feudal_States "The_Feudal_States_v1.13.zip" "The_Feudal_States_v1.13.oxp" "The_Feudal_States_v1.13.oxp/The Feudal States - Version History.rtf"
addmod Free_Trade_Zone http://wiki.alioth.net/index.php/Free_Trade_Zone "FTZ v0.15.oxp.zip" "FTZ v0.15.oxp" "Readme.rtf"
addmod Fuel_Station http://wiki.alioth.net/index.php/Fuel_Station_OXP "fuelStation_1.33.zip" "Fuel Station 1.33.oxp" "Fuel Station  v1.33 ReadMe.txt"
addmod Galactic_Navy http://wiki.alioth.net/index.php/Galactic_Navy "Galactic_Navy 5.4.3.zip" "Galactic_Navy 5.4.3/Galactic_Navy 5.4.3.oxp" "Galactic_Navy 5.4.3/Galactic Navy Readme.txt"
addmod Gates http://wiki.alioth.net/index.php/Gates_OXP "gates_1.13.zip" "Gates 1.13.oxp" "Gates  v1.13 Readme & License.txt"
addmod Globe_station http://wiki.alioth.net/index.php/Globe_station "globestation2.0.zip" "globestation2.0.oxp" "readme.rtf"
addmod Hired_Guns http://wiki.alioth.net/index.php/Hired_Guns_OXP "hiredGuns_1.25.zip" "Hired Guns 1.25.oxp" "Hired Guns v1.25 ReadMe & License.txt"
addmod HoOpy_Casino http://wiki.alioth.net/index.php/HoOpy_Casino "hOopyCasino1.2.zip" "hOopyCasino1.2/hOopyCasino1.2.oxp" "hOopyCasino1.2/ReadMe.rtf"
addmod Interstellar_help http://wiki.alioth.net/index.php/Interstellar_help_OXP "interstellar_help 2.1.zip" "interstellar_help 2.1/interstellar_help.oxp" "interstellar_help 2.1/readMe.rtf"
addmod PA_Groove_Stations http://wiki.alioth.net/index.php/P.A._Groove_Stations_OXP "PAGroove_Stations_v1.2.1.zip" "PAGroove_Stations_v1.2.1/PAGroove_Stations_v1.2.1.oxp" "PAGroove_Stations_v1.2.1/PAGroove_Stations_Background_on_stations.txt"
addmod Pirate_Coves http://wiki.alioth.net/index.php/Pirate_Coves_OXP "Pirate_coves 1.3.2.zip" "Pirate_coves 1.3.2/Pirate_coves 1.3.2.oxp" "Pirate_coves 1.3.2/about pirate_coves.txt"
addmod Planetfall http://wiki.alioth.net/index.php/Planetfall_OXP "planetFall_1.41.zip" "PlanetFall 1.41.oxp" "Planetfall v1.41 ReadMe & License.txt"
addmod Random_Hits http://wiki.alioth.net/index.php/Random_Hits_OXP "RandomHits1.4.12.zip" "RandomHits1.4.12/RandomHits1.4.12oxp.oxp" "RandomHits1.4.12/Spoilers.rtf"
addmod SIRF http://wiki.alioth.net/index.php/S.I.R.F. "SIRF20.oxp.zip" "SIRF20.oxp" "SIRF20.oxp/SIRFreadme"
addmod Superhub http://wiki.alioth.net/index.php/Superhub "Superhubv1.2.oxp.zip" "Superhubv1.2.oxp" "Superhubv1.2.oxp/Readme.txt"
addmod Taxi_Galactica http://wiki.alioth.net/index.php/Taxi_Station "Taxi_Galactica_Beta_v0.4.zip" "Taxi_Galactica.oxp" "Readme.txt"
addmod Torus_station  http://wiki.alioth.net/index.php/Torus_station "Tori2.01.zip" "Tori2.01.oxp" "Tori2.01 Readme.rtf"

defaultrights rootfs

pack rootfs $DIRNAME

clean
