#!/bin/bash
# если (auto)install.log открыт, выполняем скрипт, если нет перезапускаем c |tee autoinstall.log
if ! lsof 2> /dev/null | grep -q "install.log"  ;then
$0 "$@" 2>&1 | tee /home/$(xuserrun whoami)/install.log
exit ${PIPESTATUS[0]}
fi

export TEXTDOMAINDIR=./locale
export TEXTDOMAIN=install-helper
MSG_Copy=$(gettext  "Copy MagOS dirs")
MSG_OK=$(gettext  "Copy OK")
MSG_YN=$(gettext   "YES(y), or NO(n)")
MSG_y=$(gettext   "y")
MSG_Y=$(gettext   "Y")
MSG_wait=$(gettext   "Wait sync...")
MSG_time=$(gettext  "sync time, hours:min:sec:")

echo  "${0}:  process is not finished correctly"  > /tmp/errorcode


if [ -f /etc/initvars ] ; then
	.	 /etc/initvars
	magos_src="${SYSMNT}/layer-base/0"
else
	magos_src=/mnt/livemedia/MagOS
fi

while getopts  d:m:b:e: option ;do
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
	  "e")
          efi_dest=$OPTARG
          ;;

      
    esac
done

error () {
	echo "$(basename $0)  $1" | tee /tmp/errorcode
	sleep 5
	exit $2
	}


echo "$MSG_Copy"
echo -------------------------------------------------
echo "MagOS - $magos_dest" 
echo "MagOS-Data  - $data_dest"
echo "boot - $boot_dest"
echo "EFI - $efi_dest"
echo ------------------------------------------------- 

 

if  [ -b "$magos_dest" ] ; then
	test=$(cat /proc/mounts |grep $magos_dest | head -n 1 |awk '{print $2}')
	if [ -d "$test" ] ; then 
		magos_dest=$test
		test=""
	else
		mkdir -p /tmp/tmp_mounts/$(basename $magos_dest)
		mount $magos_dest  /tmp/tmp_mounts/$(basename $magos_dest)  || error "${LINENO}:  mount error"  1 
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
		mount $boot_dest  /tmp/tmp_mounts/$(basename $boot_dest)  || error "${LINENO}:  mount error"  1
		boot_dest="/tmp/tmp_mounts/$(basename $boot_dest)"
	fi
fi



if  [ -b "$efi_dest" ] ; then
	test=$(cat /proc/mounts |grep $efi_dest | head -n 1 |awk '{print $2}')
	if [ -d "$test" ] ; then 
		efi_dest=$test
		test=""
	else
		mkdir -p /tmp/tmp_mounts/$(basename $efi_dest)
		mount $efi_dest  /tmp/tmp_mounts/$(basename $efi_dest)  || error "${LINENO}:  mount error"  1
		efi_dest="/tmp/tmp_mounts/$(basename $efi_dest)"
	fi
fi

if  [ -b "$data_dest" ] ; then
	test=$(cat /proc/mounts |grep $data_dest | head -n 1 |awk '{print $2}')
	if [ -d "$test" ] ; then 
		data_dest=$test
	else
		mkdir -p /tmp/tmp_mounts/$(basename $data_dest)
		mount $data_dest  /tmp/tmp_mounts/$(basename $data_dest)  || error "${LINENO}:  mount error"  1
		data_dest="/tmp/tmp_mounts/$(basename $data_dest)"
	fi
fi

#echo boot destinantion: $boot_dest
#echo efi destinantion: $efi_dest


if [ -d "$magos_dest"  ] ; then
echo -------------------------------------------------
	if [ -d "$magos_src" ] ; then
	echo "Copy MagOS dir to $magos_dest"
	rsync_opt="-av"
	[ "$(cat /proc/mounts |grep "$magos_dest" | awk '{print $3}')" == "vfat" ] && rsync_opt="-rlv"
	until rsync "$rsync_opt" --progress   --exclude=*optional/* --exclude=*modules/* --exclude=*machines/dynamic/* --exclude=*machines/static/* --exclude=*rootcopy/*  $magos_src $magos_dest  ; do  
		read   -p "copy MagOS dir error, retry? $MSG_YN"   a
		[ "$a" == "y" -o "$a" == "Y" -o "$a" == "$MSG_y" -o "$a" == "$MSG_Y" ] || error "${LINENO}:  MagOS dir is not copyed" 2
	done 
	[ -d "${magos_dest}/0" ] && mv ${magos_dest}/0 ${magos_dest}/MagOS 
	echo "$MSG_OK"
	else
	error  "$magos_src is not exists"
	fi
fi 


if [ -d "$data_dest"  ] ; then
echo -------------------------------------------------
echo "Unpacking ${magos_src}/MagOS-Data.tar.bz2 to  $data_dest"
	if [ -f  "${magos_src}/MagOS-Data.tar.bz2" ] ; then
	cd "$data_dest"
	tar xvjf   "${magos_src}/MagOS-Data.tar.bz2"   && echo $MSG_OK
	else
	error "${LINENO}:  ${magos_src}/MagOS-Data.tar.bz2 is not found"
	fi
fi

if [ -d "$boot_dest"  ] ; then
echo -------------------------------------------------
	if [ -f  "${magos_src}/boot.tar.bz2" ] ; then
		echo "${magos_src}/boot.tar.bz2 to  $boot_dest"
		cd "$boot_dest"
		tar xvjf "${magos_src}/boot.tar.bz2"  && echo $MSG_OK
		[ -d "$efi_dest"  ] && mv ${boot_dest}/EFI ${efi_dest}/ && echo "EFI moved to ${efi_dest}/" 
		else
		echo ".../MagOS/boot.tar.bz2 is not found"
		echo "Continue <Y(yes)/N(no)>" ; read qqq
		case $qqq in
			N | n | no | NO )
			exit;;
			*) 
			echo "Continue..." ;; 
		esac
	fi
fi 

echo "$MSG_wait" 
echo "$MSG_time" 

/usr/bin/time  -f %E  sync
rm -f /tmp/errorcode
sleep 2
exit 0


 
