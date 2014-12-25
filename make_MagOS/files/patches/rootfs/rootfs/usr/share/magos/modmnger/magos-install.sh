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
echo ------------------------------------------------- 
magos_src=$(dirname $(./cfg.py base_path)) 

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

if [ -d "$magos_dest"  ] ; then
echo -------------------------------------------------
	if [ -d "/mnt/livemedia/MagOS" ] ; then
	echo "Copy /mnt/livemedia/MagOS to $magos_dest"
	until rsync -av --progress   --exclude=*optional/*   	--exclude=*modules/*  --exclude=*machines/dynamic/*   --exclude=*machines/static/* --exclude=*rootcopy/*  /mnt/livemedia/MagOS $magos_dest  ; do  
		read   -p "copy MagOS dir error, retry? $MSG_YN"   a
		[ "$a" == "y" -o "$a" == "Y" -o "$a" == "$MSG_y" -o "$a" == "$MSG_Y" ] || error "${LINENO}:  MagOS dir is not copyed" 2
	done 
	echo "$MSG_OK"
	else
	error  "/mnt/livemedia/MagOS is not exists"
	fi
fi 


if [ -d "$boot_dest"  ] ; then
echo -------------------------------------------------
	if [ -f  "/mnt/livemedia/MagOS/boot.tar.bz2" ] ; then
		echo "Unpacking /mnt/livemedia/MagOS/boot.tar.bz2 to  $boot_dest"
		rsync  -av  /mnt/livemedia/MagOS/boot.tar.bz2  "$boot_dest" || error "${LINENO}:  copy boot.tar.gz  error"  2
		cd $boot_dest
		tar xvjf   ./boot.tar.bz2 || error "${LINENO}: unpack boot dir error"  3
		rm -f  ./boot.tar.bz2
		echo "$MSG_OK"
	else
		echo "/mnt/livemedia/MagOS/boot.tar.bz2 is not found, try to use  /mnt/livemedia/boot"
		boot_path="/mnt/livemedia/boot"
		until [ -f "${boot_path}/Install_MagOS.bat" ] ; do 
			read -p "Please enter path to \"boot\" dir (MagOS boot dir), or push ENTER to get boot dir from repository:   "  a
			if [ -z $a ] ; then
				VERSION=$(cat /mnt/livemedia/MagOS/VERSION |awk '{print $1}')
				cd /tmp
				until wget -rt 3 ftp://magos.sibsau.ru/netlive/${VERSION}/boot  ; do
				read -p "Can not get  boot dir, retry?"
				[ "$a" == "y" -o "$a" == "Y" -o "$a" == "$MSG_y" -o "$a" == "$MSG_Y" ] || error "${LINENO}:  Boot dir is not copyed. " 2
				done
				boot_path=/tmp/magos.sibsau.ru/netlive/${VERSION}/boot
			else
				boot_path=$a
			fi
			[ "$(basename  "$boot_path")" != "boot" ] && boot_path=${boot_path}/boot 
			[ -f "${boot_path}/Install_MagOS.bat" ] || echo "Try again, or close this window to quit" 
		done
		echo "Copy $boot_path  to $boot_dest"
		rsync  -av  "$boot_path" "$boot_dest"   || error "${LINENO}:  copy boot dir error"  2
		echo "$MSG_OK"
		rm -rf  /tmp/magos.sibsau.ru  2> /dev/null
	fi
fi 


if [ -d "$data_dest"  ] ; then
echo -------------------------------------------------
echo "Unpacking /mnt/livemedia/MagOS/MagOS-Data.tar.bz2 to  $data_dest"
	if [ -f  "/mnt/livemedia/MagOS/MagOS-Data.tar.bz2" ] ; then
	rsync -av /mnt/livemedia/MagOS/MagOS-Data.tar.bz2  "$data_dest" || error "${LINENO}:  copy MagOS-Data.tar.gz  error"  2
	cd $data_dest
	tar xvjf   ./MagOS-Data.tar.bz2 || error "${LINENO}: unpack MagOS-Data dir error"  3
	rm -f  ./MagOS-Data.tar.bz2
	echo "$MSG_OK"
	else
	error "${LINENO}:  /mnt/livemedia/MagOS/MagOS-Data.tar.bz2 is not found"
	fi
fi

echo "$MSG_wait" 
echo "$MSG_time" 

/usr/bin/time  -f %E  sync
rm -f /tmp/errorcode
sleep 2
exit 0


 
