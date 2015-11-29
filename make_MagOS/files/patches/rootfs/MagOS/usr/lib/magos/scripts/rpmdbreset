#!/bin/bash
usage()
{
   echo "Warning ! This script returns rpm base to initial state!"
   echo
   echo "Usage: $0 --copy|--erase"
   echo "--copy  Will copy DB from module to rootfs. It is usefull for clean mode."
   echo "        It works immediately."
   echo "--erase Will clear changes in rootfs (/mnt/live/memory/changes/var/lib/rpm)."
   echo "        It is usefull for save change mode. It works after reboot."
   exit 1
}

if [ "$1" = "" ] ;then
   usage
fi

case "$1" in
   --copy)
     echo remove rpm DB ...
     rm -fr /var/lib/rpm
     echo copy initial rpm DB ...
     cp -pr /mnt/live/memory/images/40-1-drakconf.xzm/var/lib/rpm /var/lib
     echo Done.
     ;;
   --erase)
     echo remove rpm DB changes ...
     rm -fr /mnt/live/memory/changes/var/lib/rpm
     echo Done.
     ;;
   *)
     usage
     ;;
esac
