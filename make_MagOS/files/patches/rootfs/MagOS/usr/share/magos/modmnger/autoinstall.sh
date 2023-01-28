#!/bin/bash
[ -z "$1" ] && exit 2
[ $(id -un) != "root" ]  && exit 3
export TEXTDOMAINDIR=./locale
export TEXTDOMAIN=install-helper
#alias _="gettext -s "
MSG_Vbox=$(gettext "  You can test your new MagOS installation in Virtualbox. \n  Enter "b/bios" or "e/efi" to begin test ")
MSG_log=$(gettext   "Installation log is in autoinstall.log file, in your home folder")
MSG_wait=$(gettext   "Wait sync...")
MSG_time=$(gettext  "sync time, hours:min:sec:")

# если autoinstall.log открыт, выполняем скрипт, если нет перезапускаем c |tee autoinstall.log
if ! lsof 2> /dev/null | grep -q "autoinstall.log"  ;then
$0 "$@" 2>&1 | tee /home/$(xuserrun whoami)/autoinstall.log
exit ${PIPESTATUS[0]}
fi

PWD0=$(pwd)
device="$1"
devsize=$(fdisk -l 2>/dev/null | grep -E "^.*${device}:" |awk '{print $5}')
echo  "${0}:  process is not finished correctly"  > /tmp/errorcode

 
if  [  "$devsize"  -le 8589934592 ] ;  then
	# устройство меньше 8G, один раздел в фат
	type=type1
elif  [  "$devsize"  -le 68719476736 ] ; then
	# устройство меньше 64G, три раздела:  fat/exfat под данные, 32МиБ fat ESP (EFI) и ext4 под магос,
	type=type2
else
	# большой винт, четыре раздела, ext4(MagOS) - ESP(fat) -  swap - ext4(MagOS-Data)
	type=type3
fi

# установка в virtualbox, один раздел в ext4
lspci |grep -qi virtualbox &&  type=type4
	
error () {
	echo $1
	sleep 3
	exit $2
	}

if  [ $type == "type1" -o $type == "type4" ] ; then
	./parted.sh  $device $type ||  error "parted error" 1 
	./magos-install.sh -m ${device}1  -b ${device}1 -d ${device}1  ||  error "copy dirs error" 2
	cd  /tmp/tmp_mounts/$(basename ${device}1)/boot/magos
	./Install.bat  ||  error "bootloader install error" 3
elif  [ $type == "type2" ] ; then
	./parted.sh  $device $type ||  error "parted error" 1
	./magos-install.sh -m ${device}3  -b ${device}3 -d ${device}3 -e ${device}2 ||  error "copy dirs error" 2
	cd  /tmp/tmp_mounts/$(basename ${device}2)/boot/magos
	./Install.bat  ||  error "bootloader install error" 3
elif  [ $type == "type3" ] ; then
	./parted.sh  $device $type ||  error "parted error" 1
	./magos-install.sh -m ${device}1  -b ${device}1 -d ${device}4 -e ${device}2 ||  error "copy dirs error" 2
	cd  /tmp/tmp_mounts/$(basename ${device}1)/boot/magos
	./Install.bat  ||  error "bootloader install error" 3
fi

cd $PWD0
echo "$MSG_wait" 
echo "$MSG_time" 
/usr/bin/time  -f %E  sync

#cd /usr/share/magos/modmnger
echo -e "$MSG_Vbox"
read aaa
[ "$aaa" == "b" -o "$aaa" == "bios" ]  && ./virtualize $device
[ "$aaa" == "e" -o "$aaa" == "efi" ] && ./virtualize $device --efi 
echo "$MSG_log"
sleep 5

exit 0
	
