#!/bin/bash
while getopts  d:m:b: option ;do
    case $option in
      "h" )
          help && exit
          ;;
      "m")
          magos_dest=$OPTARG
          ;;
      "b")
          boot_dest=$OPTARG
          ;;
      "d")
          data_dest=$OPTARG
          ;;
      
    esac
done
echo "Copy MagOS Dirs" 
 
magos_src=$(dirname $(./cfg.py base_path)) 

if  [ -b "$magos_dest" ] ; then
	test=$(cat /proc/mounts |grep $magos_dest | head -n 1 |awk '{print $2}')
	if [ -d "$test" ] ; then 
		magos_dest=$test
		test=""
	else
	echo "magos-dest is not block dev"
		mkdir -p /tmp/tmp_mounts/$(basename $magos_dest)
		mount $magos_dest  /tmp/tmp_mounts/$(basename $magos_dest)
		magos_dest="/tmp/tmp_mounts/$(basename $magos_dest)"
	fi
fi
	
if  [ -b "$boot_dest" ] ; then
	test=$(cat /proc/mounts |grep $boot_dest | head -n 1 |awk '{print $2}')
	if [ -d "$test" ] ; then 
		boot_dest=$test
		test=""
	else
		mkdir -p /tmp/tmp_mounts/$(basename $boot_dest)
		mount $boot_dest  /tmp/tmp_mounts/$(basename $boot_dest)
		boot_dest="/tmp/tmp_mounts/$(basename $boot_dest)"
	fi
fi

if  [ -b "$data_dest" ] ; then
	test=$(cat /proc/mounts |grep $data_dest | head -n 1 |awk '{print $2}')
	if [ -d "$test" ] ; then 
		data_dest=$test
	else
		mkdir -p /tmp/tmp_mounts/$(basename $data_dest)
		mount $data_dest  /tmp/tmp_mounts/$(basename $data_dest)
		data_dest="/tmp/tmp_mounts/$(basename $data_dest)"
	fi
fi

if [ "$magos_dest" != "none" ] ; then
echo --------------------------------
echo "MagOS dir will copy to $magos_dest, please type \"Y\" to continue, or \"N\" no chancel"
read a
if [ $a == "y" ] ; then
	#not tested yet
	if [ -d "/mnt/livemedia/MagOS" ] ; then
	rsync -rv /mnt/livemedia/MagOS $magos_dest --progress
	else
	echo "/mnt/livemedia/MagOS is not exists"
	fi
else
echo  "copy MagOS directory skiped"
fi
fi 


if [ "$boot_dest" != "none" ] ; then
echo --------------------------------
echo "boot dir will copy to $boot_dest, please type \"Y\" to continue, or \"N\" no chancel"
read a
if [ $a == "y" ] ; then
	if [ -d "/mnt/livemedia/boot" ] ; then
	cp -rf /mnt/livemedia/boot $boot_dest 
	else
	echo "/mnt/livemedia/boot is not exists"
	fi
else
echo  "copy boot directory droped"
fi
fi 


if [ "$data_dest" != "none" ] ; then
echo -------------------------------
echo "Unpacking /mnt/livemedia/MagOS/MagOS-Data.tar.bz2 to  $data_dest,  please type \"Y\" to continue, or \"N\" no chancel"
read a
if [ $a == "y" ] ; then
	if [ -d "/mnt/livemedia/MagOS" ] ; then
	cp -f /mnt/livemedia/MagOS/MagOS-Data.tar.bz2  "$data_dest"/
	cd $data_dest
	tar xvjf  ./MagOS-Data.tar.bz2
	rm -f  ./MagOS-Data.tar.bz2
	else
	echo "/mnt/livemedia/MagOS/MagOS-Data.tar.bz2 is not found"
	fi
else
echo  "copy MagOS _Data directory droped"
fi
fi 
sync
sleep 3



 
