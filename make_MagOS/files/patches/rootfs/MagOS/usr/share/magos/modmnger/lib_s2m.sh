#!/bin/bash
path=/mnt/livemedia/MagOS
[ -d /mnt/livemedia/MagOS-Data ] && path=/mnt/livemedia/MagOS-Data
#[ -d /mnt/livedata/MagOS-Data ] && path=/mnt/livedata/MagOS-Data
MODULEFORMATS=$(./cgi-bin/cfg.py modtype)
SAVE2MODULEFORMAT=xzm

GETPATH(){
   echo $path
}

GET_ACTIVE_MODS(){
	if ! /sbin/losetup -a  >/dev/null 2>&1; then 
		beesu "/bin/bash $0 --get-mods"
		exit 0
	fi    
	for modtype in $MODULEFORMATS; do 
		$getroot /sbin/losetup -a | sed s/'.*('// | sed s/').*'// | grep -i .$modtype$ | while read a ;do 
		echo "$(basename "$a")"////"$(dirname "$a")" ;done | sort
	done 
}

MKSAVELIST() {
   [ $(id -un) != "root" ] && echo "must be root" && exit 1
   touch /.savelist
   chown $(xuserrun whoami) /.savelist 
}
MKSAVETOMODULE() {
   [ $(id -un) != "root" ] && echo "must be root" && exit 1
   echo $path/machines/dynamic/$(MODNAME).$SAVE2MODULEFORMAT > /.savetomodule
   chown $(xuserrun whoami) /.savetomodule
}

MODNAME(){
	if [ -f /.savetomodule ]; then 
		SAVETOMODULENAME=$(basename $(cat /.savetomodule))
	else
		MUID=mac-$(cat /sys/class/net/eth0/address | tr -d :)
		[ "$MUID" = "mac-" ] && MUID=vga-$(lspci -mmn | grep -i 0300 | md5sum | cut -c 1-12)
		SAVETOMODULENAME=$MUID.$SAVE2MODULEFORMAT
	fi	
echo $SAVETOMODULENAME
}

STATUS(){
	status=cmd_disabled
	SAVETOMODULENAME=$(MODNAME)
	cat /proc/cmdline |grep -q "changes=xzm" &&  status=cmd_enabled
	if [ -f /.savetomodule ] ; then
	  status=${status}" "f_enabled
	 else 
	 status=${status}" "f_disabled
	fi
	if ls $path/machines/static |egrep -q "$SAVETOMODULENAME" ; then
		status=${status}" "static" "${path}/machines/static/${SAVETOMODULENAME}
	elif 	ls $path/machines/dynamic |egrep -q "$SAVETOMODULENAME" ; then 
		status=${status}" "dynamic" "${path}/machines/dynamic/${SAVETOMODULENAME}
	else
		status=${status}" "no_saves" "${path}/machines/dynamic/${SAVETOMODULENAME}
	fi
		
	echo "$status"  
}

TOGGLE() {
   [ $(id -un) != "root" ] && echo "must be root" && exit 1
	status=$(STATUS) 
	save_status=$(echo $status | awk '{print $3}')
	SAVETOMODULENAME=$(echo $status | awk '{print $4}')
   if [ $save_status == "static" ] ; then
		mv $SAVETOMODULENAME $path/machines/dynamic/
   elif [ $save_status == "dynamic" ] ; then
		mv $SAVETOMODULENAME $path/machines/static/
   else
		exit 2
   fi
}

HELP()
{
   cat <<EOF
Script to control SAVETOMODULE mode
Usage:
--status     (get save2module mode status)
--getpath    (get path to MagOS-Data dir)
--toggle     (dynamic to static toggle)
--mksavelist (make empty /.savelist file)
--help
EOF
}

cmd="$1"

[ "_$cmd" = "_" ] &&  cmd="--status" 

case $cmd in
   -h | --help )
      HELP ;;
   --status )
      STATUS ;;
   --toggle )
      TOGGLE ;;
   --modname )
      MODNAME ;;
   --mksavelist )
      MKSAVELIST ;;
   --mksavetomodule )
      MKSAVETOMODULE ;;
   --getpath )
      GETPATH ;;
   --get-mods )
      GET_ACTIVE_MODS ;;
esac

exit 0
