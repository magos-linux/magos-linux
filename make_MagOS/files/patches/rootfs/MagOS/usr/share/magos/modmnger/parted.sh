#!/bin/bash
[ -z "$2" ] && exit 2
[ $(id -un) != "root" ]  && exit 3 

# если install.log или autoinstall.log открыт, выполняем скрипт, если нет перезапускаем c |tee autoinstall.log
if ! lsof 2> /dev/null | grep -q "install.log"  ;then
$0 "$@" 2>&1 | tee /home/$(/usr/lib/magos/scripts/xuserrun whoami)/install.log
exit ${PIPESTATUS[0]}
fi

export TEXTDOMAINDIR=./locale
export TEXTDOMAIN=install-helper

MSG_size=$(gettext  "Size for partition ")
MSG_fs=$(gettext  "FS for partition ")
MSG_continue=$(gettext     "Please push ENTER to continue, or close this window to abort.")
MSG_space=$(gettext "Not enough disk space for all partitions")
MSG_wrn1=$(gettext  "Warning, partition for MagOS-Data is:  ") 
MSG_wrn2=$(gettext "It is not enough.")

type=$2
device=$1
devsize=$(fdisk -l 2>/dev/null |grep Disk.*${device} |awk '{print $5}')
echo  "${0}:  process is not finished correctly"  > /tmp/errorcode

error () {
	echo "$(basename $0)  $1" | tee /tmp/errorcode
	sleep 5
	exit "$2"
	}

# тип первый: весь раздел в fat ли ntfs
type1 () {
	part1=$(($devsize / 1000 / 1000))	
	fs_part1=vfat
	[ "$part1" -gt  8000 ] && fs_part1=ntfs
	echo "----------------------------------------------"
	echo "$MSG_size 1:   $(echo "scale=2;  $part1 / 1000" | bc) GB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"
	read -p "$MSG_continue  "
	
	try_to_clear
	
	if [ "$fs_part1" == "ntfs" ] ; then
		parted  -a optimal -s $device   mkpart primary  NTFS 0% 100%  || error "${LINENO}: Parted error" 5 
		mkfs.ntfs -f -L magos ${device}1 || error "${LINENO}: mkfs error"  6
	else
		parted  -a optimal -s $device   mkpart primary  FAT32 0% 100% || error "${LINENO}: Parted error" 5
		mkfs.vfat -F 32 -n magos ${device}1  || error "${LINENO}: mkfs error"  6
    fi
}

# тип второй: воторой раздел 2GB под магос, первый под данные fat или nfs
type2 () {
	part1=$((($devsize  - 2300000000) / 1000 / 1000))
	[ "$part1" -lt 500 ] && error "$MSG_space"  7  
	part2=2000
	fs_part1=fat32
	[ "$part1" -gt  4000 ] && fs_part1=ntfs
	fs_part2=ext3
	echo "----------------------------------------------"
	echo "$MSG_size 1:  $(echo "scale=2;  $part1 / 1000" | bc) GB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"
	echo "$MSG_size 2:  $(echo "scale=2;  $part2 / 1000" | bc) GB"
	echo "$MSG_fs 2:  $fs_part2"
	echo "----------------------------------------------"
	
	read -p "$MSG_continue  "
	try_to_clear
	
	# первый диск начинается с 1мб, а не с нуля. Без этого не работает выравнивание и иногда ругается на нехватку места bootinst_mbr.sh
	# почему не знаю, пока не разбирался. 1мб не жалко :)
	if [ "$fs_part1" ==  "ntfs" ] ; then
		parted   -a optimal  -s $device  mkpart primary  NTFS 1  $part1  || error "${LINENO}: Parted error" 5
		mkfs.ntfs  -f -L data ${device}1  || error "${LINENO}: mkfs error"  6
	else
		parted  -a  optimal -s $device  mkpart primary  FAT32 1 $part1 || error "${LINENO}: Parted error" 5
		mkfs.vfat -F 32 -n data ${device}1 || error "${LINENO}: mkfs error"  6
    fi
	
	parted  -a optimal -s $device  mkpart primary  EXT3  $part1 100% || error "${LINENO}: Parted error" 5
	mkfs.ext3 -L magos ${device}2 || error "${LINENO}: mkfs error"  6
	 
}

# тип третий: MagOS - swap - MagOS-Data
type3 () {
		fs_part1=ext2
		fs_part3=ext3
		part1=$((($devsize  - 2147483648) / 1024 / 1024 / 10))
		[ "$part1" -lt 2048 ] && part1=2048
		[ "$part1" -gt 20000 ] && part1=20000
		part_swap=$(expr $(free -m |grep Mem: |awk '{print $2}')  \*  2)
		part3=$(expr $devsize / 1000000 - $part1 - $part_swap)
		[ "$part3" -lt 1000 ] && error "$MSG_space"  7
		[ "$part3" -lt 2000 ] && echo "$MSG_wrn1 ${part3}.  $MSG_wrn2"  
		echo "----------------------------------------------" 
		echo "$MSG_size 1:  $(echo "scale=2;  $part1 / 1000" | bc) GB"
		echo "$MSG_fs 1:  $fs_part1"
		echo "----------------------------------------------"
		echo "$MSG_size 2:  $(echo "scale=2;  $part_swap  / 1000" | bc) GB"
		echo "$MSG_fs 2:  linux-swap"
		echo "----------------------------------------------"
		echo "$MSG_size 3:  $(echo "scale=2;  $part3 / 1000" | bc) GB)"
		echo "$MSG_fs 3:  $fs_part3"
		echo "----------------------------------------------"
		
		read -p "$MSG_continue  "
		
		try_to_clear
		parted  -a optimal -s $device  mkpart primary  $fs_part1  1 $part1  || error "${LINENO}: Parted error" 5
		mkfs.$fs_part1  -L magos ${device}1  || error "${LINENO}: mkfs error"  6
		parted  -a optimal -s $device  mkpart primary linux-swap  $part1 $(($part1 + $part_swap))  || error "${LINENO}: Parted error" 5
		mkswap  ${device}2  || error "${LINENO}: mkfs error"  6
		parted  -a optimal -s $device  mkpart primary  $fs_part3   $(($part1 + $part_swap)) 100% || error "${LINENO}: Parted error" 5
		mkfs.$fs_part3  -L magos-data ${device}3 || error "${LINENO}: mkfs error"  6
		
}
# четвертый: все в ext3 (в основном для виртуалок)
type4 () {
	part1=$(($devsize / 1000 / 1000))
	fs_part1=ext3
	echo "----------------------------------------------"
	echo "$MSG_size 1:   $(echo "scale=2;  $part1 / 1000" | bc) GB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"

	read -p "$MSG_continue  "
	
	try_to_clear
	
	parted  -a optimal -s $device   mkpart primary  $fs_part1 0% 100% || error "${LINENO}: Parted error" 5
	mkfs.$fs_part1  -L magos ${device}1 || error "${LINENO}: mkfs error"  6
}
# все в фат32
type5 () {
	part1=$(($devsize / 1000 / 1000))	
	fs_part1=fat32
	echo "----------------------------------------------"
	echo "$MSG_size 1:   $(echo "scale=2;  $part1 / 1000" | bc) GB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"

	read -p "$MSG_continue  "
	
	try_to_clear

	parted  -a optimal -s $device   mkpart primary  FAT32 0% 100% || error "${LINENO}: Parted error" 5
	mkfs.vfat -F 32 -n magos ${device}1  || error "${LINENO}: mkfs error"  6
}

#все в ntfs
type6 () {
	part1=$(($devsize / 1000 / 1000))
	fs_part1=ntfs
	echo "----------------------------------------------"
	echo "$MSG_size 1:   $(echo "scale=2;  $part1 / 1000" | bc) GB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"

	read -p "$MSG_continue  "
	
	try_to_clear

	parted  -a optimal -s $device   mkpart primary  NTFS 0% 100%  || error "${LINENO}: Parted error" 5
	mkfs.ntfs -f -L magos ${device}1  || error "${LINENO}: mkfs error"  6
	
}





try_to_clear () {
	if cat /proc/mounts |grep -q $device ; then
		echo "Trying to unmount disks..."
		for dev in  `ls -1 ${device}* |grep [[:digit:]]` ; do
			if cat /proc/mounts |grep -q $dev ; then	
				echo "unmounting $dev"
				umount $dev || error "${LINENO}: Sorry, can not unmount $dev" 2
			fi
		done
	fi
	swapon |grep -q $device  && error "${LINENO}: Sorry, swap partition from $dev is in use" 3
	#Удаление mbr и проверка на запись. Полезно если флешку не видит gparted
	dd if=/dev/zero of=$device bs=512 count=1
	dd if=$device bs=512 count=1 |hexdump | grep -q "0000000 0000 0000 0000 0000 0000 0000 0000 0000" || error "${LINENO}: Sorry,  drive $device is dead :( " 4  
	parted -s $device mklabel msdos
	}
		
case $type in
	type1)
	type1;;
	type2)
	type2;;
	type3)
	type3;;
	type4)
	type4;;
	type5)
	type5;;
	type6)
	type6;;
esac

rm -f /tmp/errorcode
exit 0
