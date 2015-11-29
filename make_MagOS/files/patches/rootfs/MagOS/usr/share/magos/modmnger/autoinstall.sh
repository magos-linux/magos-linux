#!/bin/bash
[ -z "$1" ] && exit 2
[ $(id -un) != "root" ]  && exit 3
export TEXTDOMAINDIR=./locale
export TEXTDOMAIN=install-helper
#alias _="gettext -s "
MSG_Vbox=$(gettext "You can test your new MagOS installation in Virtualbox. ")
MSG_log=$(gettext   "Installation log is in autoinstall.log file, in your home folder")
MSG_YN=$(gettext   "YES(y), or NO(n)")
MSG_y=$(gettext   "y")
MSG_Y=$(gettext   "Y")
MSG_wait=$(gettext   "Wait sync...")
MSG_time=$(gettext  "sync time, hours:min:sec:")

# если autoinstall.log открыт, выполняем скрипт, если нет перезапускаем c |tee autoinstall.log
if ! lsof 2> /dev/null | grep -q "autoinstall.log"  ;then
$0 "$@" 2>&1 | tee /home/$(xuserrun whoami)/autoinstall.log
exit ${PIPESTATUS[0]}
fi


device="$1"
devsize=$(fdisk -l 2>/dev/null |grep Disk.*${device} |awk '{print $5}')
echo  "${0}:  process is not finished correctly"  > /tmp/errorcode

 
if  [  "$devsize"  -le 4294967296 ] ;  then
	# устройство меньше 4G, один раздел в фат 
	type=type1
elif  [  "$devsize"  -le 68719476736 ] ; then
	# устройство меньше 64G, два раздела ext3 под магос и fat/ntfs под данные
	type=type2
else
	# большой винт, три раздела, ext2 -  swap - ext3
	type=type3
fi

# установка в virtualbox, один раздел в ext3
lspci |grep -qi virtualbox &&  type=type4
	
error () {
	echo $1
	sleep 3
	exit $2
	}

if  [ $type == "type1" -o $type == "type4" ] ; then
	./parted.sh  $device $type ||  error "parted error" 1 
	./magos-install.sh -m ${device}1  -b ${device}1 -d ${device}1  ||  error "copy dirs error" 2
	cd  /tmp/tmp_mounts/$(basename ${device}1)/boot
	./Install_MagOS.bat  ||  error "bootloader install error" 3
elif  [ $type == "type2" ] ; then
	./parted.sh  $device $type ||  error "parted error" 1
	./magos-install.sh -m ${device}2  -b ${device}2 -d ${device}2  ||  error "copy dirs error" 2
	cd  /tmp/tmp_mounts/$(basename ${device}2)/boot
	./Install_MagOS.bat  ||  error "bootloader install error" 3
elif  [ $type == "type3" ] ; then
	./parted.sh  $device $type ||  error "parted error" 1
	./magos-install.sh -m ${device}1  -b ${device}1 -d ${device}3  ||  error "copy dirs error" 2
	cd  /tmp/tmp_mounts/$(basename ${device}1)/boot
	./Install_MagOS.bat  ||  error "bootloader install error" 3
fi


echo "$MSG_wait" 
echo "$MSG_time" 
/usr/bin/time  -f %E  sync

cd /usr/share/magos/modmnger
echo "$MSG_Vbox"
echo "$MSG_YN"
read a
[ "$a" == "y" -o "$a" == "Y" -o "$a" == "$MSG_y" -o "$a" == "$MSG_Y" ] && ./virtualize $device
echo "$MSG_log"
 
sleep 5

exit 0
	
