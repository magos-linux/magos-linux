#!/bin/bash
[ -z "$1" ] && exit 2
[ $(id -un) != "root" ]  && exit 3
device="$1"
devsize=$(fdisk -l |grep Disk.*${device} |awk '{print $5}')
 
if  [  "$devsize"  -le 4294967296 ] ;  then
	# устройство меньше 4G, один раздел в фат 
	type=type1
elif  [  "$devsize"  -le 68719476736 ] ; then
	# устройство меньше 64G, два раздела ext3 под магос и fat/ntfs под данные
	type=type2
else
	# большой винт, три раздела, ext2 -  swap - ext3
	type=type2
fi

#для тестирования
#type=type1

if  [ $type="type1" ] ; then
	./parted.sh  $device $type
	./magos-install.sh -m ${device}1  -b ${device}1 -d ${device}1
	cd  /tmp/tmp_mounts/$(basename ${device}1)/boot
	./Install_MagOS.bat
elif  [ $type="type2" ] ; then
	./parted.sh  $device $type
	./magos-install.sh -m ${device}2  -b ${device}2 -d ${device}2
	cd  /tmp/tmp_mounts/$(basename ${device}2)/boot
	./Install_MagOS.bat
else
	./parted.sh  $device $type
	./magos-install.sh -m ${device}1  -b ${device}1 -d ${device}3
	cd  /tmp/tmp_mounts/$(basename ${device}1)/boot
	./Install_MagOS.bat
fi


	
