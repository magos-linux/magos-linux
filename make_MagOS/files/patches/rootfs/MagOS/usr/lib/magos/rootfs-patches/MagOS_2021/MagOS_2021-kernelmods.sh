#!/bin/bash
#BUGFIX same kernel names for nvidia drivers
if find /lib/modules -type f -name nvidia.ko | nl -n'ln' | grep -q ^2 ;then
  find /lib/modules -type f -name nvidia.ko | while read a ;do
      KDIR=$(dirname $a)
      KDIR=$(basename $KDIR)
      echo "$KDIR" | grep -q ^nvidia[0-9]*$ && rename "nvidia" "$KDIR" $(dirname $a)/nvidia*
  done
fi
#BUGFIX dkms mkrpm currently broken, so we have to install all dkms binary modules
for a in /var/lib/dkms-binary/* ;do
  [ -d "$a" ] || continue
  grep BUILT_MODULE_NAME "$a"/*/*/dkms.conf | tr -d \"\' | while read b ;do
     KERN=$(dirname "$a"/*/*/dkms.conf)
     KERN=$(basename "$KERN")
     MODULE=$(echo $b | awk -F= '{print $2}')
     PLACEKEY=$(echo $b | sed s/BUILT_MODULE_NAME/DEST_MODULE_LOCATION/ | awk -F= '{print $1}' | tr '[]' .)
     PLACELOC=$(grep $PLACEKEY= "$a"/*/*/dkms.conf | awk -F= '{print $2}' | tr -d \"\')
     [ -z "PLACELOC" ] && PLACELOC=3rdparty/$(basename $a)
     mkdir -p /lib/modules/$KERN$PLACELOC
     cp -pf $a/*/*/*/module/$MODULE.ko* /lib/modules/$KERN$PLACELOC
  done
done

#remove dead link
rm -f /lib/modules/*/kernel/zzz-*-abi

depmod -a

exit 0
