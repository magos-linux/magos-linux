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
devsize=$(fdisk -l 2>/dev/null |egrep "^.*${device}:"  |awk '{print $5}')
echo  "${0}:  process is not finished correctly"  > /tmp/errorcode

error () {
	echo "$(basename $0)  $1" | tee /tmp/errorcode
	sleep 5
	exit "$2"
	}

# тип первый: весь раздел в fat
type1 () {
	part1=$(($devsize / 1024 / 1024))	
	fs_part1=vfat
	echo "----------------------------------------------"
	echo "$MSG_size 1:  $(echo "scale=2;  $part1 / 1024" | bc) Gib"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"
	read -p "$MSG_continue  "
	
	try_to_clear
	
	parted  -a optimal -s $device   mkpart FAT32   1MiB 100% || error "${LINENO}: Parted error" 5
	mkfs.vfat -F 32 -n MAGOS ${device}1  || error "${LINENO}: mkfs error"  6

}

#тип второй: третий раздел 5GB под магос, второй 32метра под EFI, первый под данные fat или exfat
type2 () {
	part1=$((($devsize  / 1024 / 1024 ) - 32 - 5120 ))
	[ "$part1" -lt 512 ] && error "$MSG_space"  7
	part2=32
	part3=5120
	fs_part1=fat32
	[ "$part1" -gt  4048 ] && fs_part1=exfat
	fs_part2=fat16
	fs_part3=ext4
	echo "----------------------------------------------"
	echo "$MSG_size 1:  $(echo "scale=2;  $part1 / 1024" | bc) GiB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"
	echo "$MSG_size 2:  $part2 MiB"
	echo "$MSG_fs 2:  $fs_part2"
	echo "----------------------------------------------"
	echo "$MSG_size 3:  $(echo "scale=2;  $part3 / 1024" | bc) GiB"
	echo "$MSG_fs 3:  $fs_part3"
	echo "----------------------------------------------"
	
	read -p "$MSG_continue  "
	try_to_clear
	
	if [ "$fs_part1" ==  "exfat" ] ; then
		parted   -a optimal  -s $device  mkpart DATA 1MiB  $(($part1 + 1))MiB  || error "${LINENO}: Parted error" 5
		mkfs.exfat -n DATA ${device}1  || error "${LINENO}: mkfs error"  6
	else
		parted  -a  optimal -s $device  mkpart DATA 1MiB $(($part1 + 1))MiB || error "${LINENO}: Parted error" 5
		mkfs.vfat -F 32 -n data ${device}1 || error "${LINENO}: mkfs error"  6
    fi
    
    parted  -a  optimal -s $device  mkpart ESP $(( $part1 +1 ))MiB $(($part1 + $part2 + 1))MiB set 2 esp on || error "${LINENO}: Parted error" 5
	mkfs.vfat -F 16 -n EFI ${device}2 || error "${LINENO}: mkfs error"  6
	
	parted  -a optimal -s $device  mkpart MAGOS $(($part1 + $part2 + 1))MiB  100% || error "${LINENO}: Parted error" 5
	mkfs.ext4 -L MAGOS ${device}3 || error "${LINENO}: mkfs error"  6
	tune2fs -m 0 ${device}3
}

# тип третий: MagOS - EFI - SWAP - MagOS-Data
type3 () {
		fs_part1=ext4
		fs_part2=fat32
		fs_part4=ext4
		part1=$(($devsize / 1024 / 1024 / 10))
		[ "$part1" -lt 4096 ] && part1=4096
		[ "$part1" -gt 20480 ] && part1=20480
		part2=100
		part3=$(expr $(free -m |grep Mem: |awk '{print $2}')  \*  2)
		[ $part3 -gt 10240 ] && part3=10240
		part4=$(expr $devsize / 1024 / 1024 - $part1 - $part2 - $part3 )
		[ "$part4" -lt 1000 ] && error "$MSG_space"  7
		[ "$part4" -lt 2000 ] && echo "$MSG_wrn1 ${part4}.  $MSG_wrn2"  
		echo "----------------------------------------------" 
		echo "$MSG_size 1:  $(echo "scale=2;  $part1 / 1024" | bc) GiB"
		echo "$MSG_fs 1:  $fs_part1"
		echo "----------------------------------------------"
		echo "$MSG_size 2:  $part2 MiB"
		echo "$MSG_fs 2:  $fs_part2"
		echo "----------------------------------------------"
		echo "$MSG_size 3:  $(echo "scale=2;  $part3  / 1024" | bc) GiB"
		echo "$MSG_fs 3:  linux-swap"
		echo "----------------------------------------------"
		echo "$MSG_size 4:  $(echo "scale=2;  $part4 / 1024" | bc) GiB"
		echo "$MSG_fs 4:  $fs_part4"
		echo "----------------------------------------------"
		
		read -p "$MSG_continue  "
		
		try_to_clear
		parted  -a optimal -s $device  mkpart MAGOS  1MiB $(($part1 + 1))MiB  || error "${LINENO}: Parted error" 5
		mkfs.$fs_part1  -L MAGOS ${device}1  || error "${LINENO}: mkfs error"  6
		tune2fs -m 0 ${device}1
		
		parted  -a  optimal -s $device  mkpart ESP $(($part1 + 1))MiB $(($part1 + $part2 + 1))MiB set 2 esp on || error "${LINENO}: Parted error" 5
		mkfs.vfat -F 32 -n EFI ${device}2 || error "${LINENO}: mkfs error"  6
				
		parted  -a optimal -s $device  mkpart linux-swap  $(($part1 + $part2 + 1))MiB $(($part1 + $part2 + $part3 + 1))MiB  || error "${LINENO}: Parted error" 5
		mkswap  ${device}3  || error "${LINENO}: mkfs error"  6
		parted  -a optimal -s $device  mkpart MAGOS-DATA  $(($part1 + $part2 + $part3 + 1))MiB 100% || error "${LINENO}: Parted error" 5
		mkfs.$fs_part4  -L MAGOS-DATA ${device}4 || error "${LINENO}: mkfs error"  6
		tune2fs -m 0 ${device}4
}
# четвертый: все в ext4 (в основном для виртуалок)
type4 () {
	part1=$(($devsize / 1024 / 1024))
	fs_part1=ext4
	echo "----------------------------------------------"
	echo "$MSG_size 1:   $(echo "scale=2;  $part1 / 1024" | bc) GiB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"

	read -p "$MSG_continue  "
	
	try_to_clear
	
	parted  -a optimal -s $device   mkpart  $fs_part1 0% 100% || error "${LINENO}: Parted error" 5
	mkfs.$fs_part1  -L magos ${device}1 || error "${LINENO}: mkfs error"  6
}

#все в ntfs
type5 () {
	part1=$(($devsize / 1024 / 1024))
	fs_part1=ntfs
	echo "----------------------------------------------"
	echo "$MSG_size 1:   $(echo "scale=2;  $part1 / 1024" | bc) GiB"
	echo "$MSG_fs 1:  $fs_part1"
	echo "----------------------------------------------"

	read -p "$MSG_continue  "
	
	try_to_clear

	parted  -a optimal -s $device   mkpart  NTFS 0% 100%  || error "${LINENO}: Parted error" 5
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
	parted -s $device mklabel gpt
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
