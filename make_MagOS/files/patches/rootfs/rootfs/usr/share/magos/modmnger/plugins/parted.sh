#!/bin/bash
[ -z "$2" ] && exit 2
[ $(id -un) != "root" ]  && exit 3 
type=$2
device=$1
devsize=$(fdisk -l |grep Disk.*${device} |awk '{print $5}')

type1 () {
	part1=$devsize	
	fs_part1=vfat
	[ "$devsize" -gt  4294967296 ] && fs_part1=ntfs
	echo "----------------------------------------------"
	echo "Size of partition 1:   $(echo "scale=2;  $part1 / 1000000" | bc) MB"
	echo "FS for partition 1 is:  $fs_part1"
	echo "----------------------------------------------"
	echo "Enter \"Y\" to continue, or \"N\" to chancel"
	read a
	[ $a != y ] && exit 4   
	try_to_clear
	if [ "$part1" -gt  4294967296 ] ; then
		parted  -a optimal -s $device   mkpart primary  NTFS 0% 100% 
		mkfs.ntfs -L magos ${device}1
	else
		parted  -a optimal -s $device   mkpart primary  FAT32 0% 100%
		mkfs.vfat -F 32 -n magos ${device}1 
    fi
}
	
type2 () {
	part1=$((($devsize  - 2000000000) / 1000 / 1000))
	part2=2000
	fs_part1=fat32
	[ "$part1" -gt  4000 ] && fs_part1=ntfs
	fs_part2=ext3
	echo "----------------------------------------------"
	echo "Size of partition 1:  $part1 MB"
	echo "FS for partition 1 is:  $fs_part1"
	echo "----------------------------------------------"
	echo "Size of partition 2:  $part2 MB"
	echo "FS for partition 2 is:  $fs_part2"
	echo "----------------------------------------------"
	echo "Enter \"Y\" to continue, or \"N\" to chancel"
	read a
	[ $a != y ] && exit 4  
	try_to_clear
	
	if [ "$fs_part1" ==  "ntfs" ] ; then
		parted   -a optimal  -s $device  mkpart primary  NTFS 0  $part1 
		mkfs.ntfs  -L data ${device}1
	else
		parted  -a  optimal -s $device  mkpart primary  FAT32 0 $part1
		mkfs.vfat -F 32 -n data ${device}1 
    fi
	
	parted  -a optimal -s $device  mkpart primary  EXT3  $part1 100%
	mkfs.ext3 -L magos ${device}2
	 
}
	
type3 () {
		fs_part1=ext2
		fs_part3=ext3
		part1=$((($devsize  - 2147483648) / 1000 / 1000 / 10))
		[ "$part1" -lt 2000 ] && part1=2000
		[ "$part1" -gt 20000 ] && part1=20000
		part_swap=$(expr $(free -m |grep Mem: |awk '{print $2}')  \*  2)
		part3=$(expr $devsize / 1000000 - $part1 - $part_swap)
		echo "----------------------------------------------"
		echo "Size of partition 1:  $part1 MB"
		echo "FS for partition 1 is:  $fs_part1"
		echo "----------------------------------------------"
		echo "Size of partition 2:  $part_swap MB"
		echo "FS for partition 2 is:  linux-swap"
		echo "----------------------------------------------"
		echo "Size of partition 3:  $part3 MB)"
		echo "FS for partition 3 is:  $fs_part3"
		echo "----------------------------------------------"
		echo "Enter \"Y\" to continue, or \"N\" to chancel"
		read a
		[ $a != y ] && exit 4
		try_to_clear
		parted  -a optimal -s $device  mkpart primary  $fs_part1  0 $part1 
		mkfs.$fs_part1  -L magos ${device}1
		parted  -a optimal -s $device  mkpart primary linux-swap  $part1 $(($part1 + $part_swap)) 
		mkswap  ${device}2
		parted  -a optimal -s $device  mkpart primary  $fs_part3   $(($part1 + $part_swap)) 100%
		mkfs.$fs_part3  -L magos-data ${device}3
		
}

try_to_clear () {
	if cat /proc/mounts |grep -q $device ; then
		echo "Trying to unmount disks..."
		for dev in  `ls -1 ${device}* |grep [[:digit:]]` ; do
			if cat /proc/mounts |grep -q $dev ; then	
				echo $dev
				umount $dev 
				[ "$?" -ne "0" ]  && echo "Sorry, can't unmount $dev !!!" && sleep 10 && exit 5
			fi
		done
	fi
	parted -s $device mklabel msdos
	}
		
case $type in
	type1)
	type1;;
	type2)
	type2;;
	type3)
	type3;;
esac
sleep 5
exit 0
