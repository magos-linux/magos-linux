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
addmod Anarchies http://wiki.alioth.net/index.php/Anarchies_OXP "Anarchies v 2.8.zip" "Anarchies v 2.8/Anarchies2.8.oxp" "Anarchies v 2.8/readMe.rtf"
addmod Bank_of_the_Black_Monks http://wiki.alioth.net/index.php/Black_Monk_Monastery "Shady_blackmonks_v1.46.zip" "Shady_blackmonks_v1.46/Shady_blackmonks_v1.46.oxp" "Shady_blackmonks_v1.46/readme.txt"
addmod BlOomberg_Markets http://www.arcadia-digital.net/steve/Oolite/Flavours.html "BlOomberg_Markets_v2.5.zip" "BlOomberg_Markets_v2.5/BlOomberg Markets v2.5.oxp" "BlOomberg_Markets_v2.5/BlOomberg Markets v2.5 Readme.rtf"
addmod BuoyRepair http://wiki.alioth.net/index.php/BuoyRepair "buoyRepair1.3.2.zip" "buoyRepair1.3.2.oxp" "BuoyRepair1.3.2 readMe.rtf"
addmod Commies http://wiki.alioth.net/index.php/Commies "Commies 2.11.zip" "Commies 2.11/Commies.oxp" "Commies 2.11/commies.txt"
addmod Dictators http://wiki.alioth.net/index.php/Dictators_OXP "Dictators_v1.5.zip" "Dictators v1.5/Dictators v1.5.oxp" "Dictators v1.5/System Profiles v1.0.pdf"
addmod Escort_Contracts http://wiki.alioth.net/index.php/Escort_Contracts_OXP "Escort_Contracts_1.5.6_2012-05-07.zip" "Escort_Contracts_1.5.6_2012-05-07.oxp" "readme.rtf"
addmod Factions http://wiki.alioth.net/index.php/Factions_OXP "Factions-1.12.oxp.zip" "Factions-1.12.oxp" "Factions-Readme.txt"
addmod Feudal_States http://wiki.alioth.net/index.php/Feudal_States "The_Feudal_States_v1.15.zip" "The_Feudal_States_v1.15/The_Feudal_States_v1.15.oxp" "The_Feudal_States_v1.15/The Feudal States - Version History.rtf"
addmod Fuel_Station http://wiki.alioth.net/index.php/Fuel_Station_OXP "fuelStation_1.34.zip" "Fuel Station 1.34.oxp" "Fuel Station  v1.34 ReadMe.txt"
addmod Free_Trade_Zone http://wiki.alioth.net/index.php/Free_Trade_Zone "FTZ v0.15.oxp.zip" "FTZ v0.15.oxp" "Readme.rtf"
addmod Galactic_Navy http://wiki.alioth.net/index.php/Galactic_Navy "Galactic_Navy 5.4.3.zip" "Galactic_Navy 5.4.3/Galactic_Navy 5.4.3.oxp" "Galactic_Navy 5.4.3/Galactic Navy Readme.txt"
addmod Gates http://wiki.alioth.net/index.php/Gates_OXP "gates_1.13.zip" "Gates 1.13.oxp" "Gates  v1.13 Readme & License.txt"
addmod Globe_station http://wiki.alioth.net/index.php/Globe_station "globestation2.0.zip" "globestation2.0.oxp" "readme.rtf"
addmod Hired_Guns http://wiki.alioth.net/index.php/Hired_Guns_OXP "hiredGuns_1.26.zip" "Hired Guns 1.26.oxp" "Hired Guns v1.26 ReadMe & License.txt"
addmod HoOpy_Casino http://wiki.alioth.net/index.php/HoOpy_Casino "hOopyCasino1.2.1.zip" "hOopyCasino1.2.1/hOopyCasino1.2.1.oxp" "hOopyCasino1.2.1/ReadMe.rtf"
addmod Interstellar_help http://wiki.alioth.net/index.php/Interstellar_help_OXP "interstellar_help 2.1.zip" "interstellar_help 2.1/interstellar_help.oxp" "interstellar_help 2.1/readMe.rtf"
addmod PA_Groove_Stations http://wiki.alioth.net/index.php/P.A._Groove_Stations_OXP "PAGroove_Stations_v1.3.3.zip" "PAGroove_Stations_v1.3.3/PAGroove_Stations_v1.3.3/PAGroove_Stations_v1.3.3.oxp" "PAGroove_Stations_v1.3.3/PAGroove_Stations_v1.3.3/PAGroove_Stations_Background_on_stations.rtf"
addmod Pirate_Coves http://wiki.alioth.net/index.php/Pirate_Coves_OXP "Pirate_coves 1.3.3.zip" "Pirate_coves 1.3.3/Pirate_coves 1.3.3.oxp" "Pirate_coves 1.3.3/about pirate_coves.txt"
addmod Planetfall http://wiki.alioth.net/index.php/Planetfall_OXP "planetFall_1.50.zip" "PlanetFall 1.50.oxp" "Planetfall v1.50 ReadMe & License.txt"
addmod Random_Hits http://wiki.alioth.net/index.php/Random_Hits_OXP "RandomHits1.4.17.zip" "RandomHits1.4.17/RandomHits1.4.17.oxp" "RandomHits1.4.17/ReadMe.rtf"
addmod SIRF http://wiki.alioth.net/index.php/S.I.R.F. "SIRF2-4.zip" "SIRF2-4.oxp" "SIRF2-4.oxp/SIRFreadme.rtf"
addmod Superhub http://wiki.alioth.net/index.php/Superhub "Superhubv1.4.zip" "Superhubv1.4/Superhubv1.4.oxp" "Superhubv1.4/Readme.txt"
addmod Taxi_Galactica http://wiki.alioth.net/index.php/Taxi_Station "Taxi Galactica v1.0.oxp.zip" "Taxi Galactica.oxp" "readme.txt"
addmod Torus_station  http://wiki.alioth.net/index.php/Torus_station "Tori2.01.zip" "Tori2.01.oxp" "Tori2.01 Readme.rtf"
addmod UPS_Courier http://wiki.alioth.net/index.php/UPS_Courier "UPS-courier v1.7.12.zip" "UPS-courier v1.7.12/UPS-courier v1.7.12.oxp" "UPS-courier v1.7.12/Read Me (version 1.7.x).rtf"
echo

defaultrights rootfs

nopack rootfs $DIRNAME

clean
