#!/bin/bash
KLIBDIR=/lib/modules
[ -d "$KLIBDIR" ] || KLIBDIR=/usr$KLIBDIR

#BUGFIX same kernel names for nvidia drivers
if find $KLIBDIR -type f -name nvidia.ko | nl -n'ln' | grep -q ^2 ;then
  find $KLIBDIR -type f -name nvidia.ko | while read a ;do
      KDIR=$(dirname $a); KDIR=$(basename $KDIR)
      echo "$KDIR" | grep -q ^nvidia[0-9]*$ && rename "nvidia" "$KDIR" $(dirname $a)/nvidia*
  done
fi
KROKDIR=/usr/share/auto-krokodil/kmods
if [ -d "$KROKDIR" ] ;then
  find "$KROKDIR" -type f -name nvidia.ko | while read a ;do
      KDIR=$(dirname $a); KDIR=$(basename $KDIR) ; KDIR=$(echo $KDIR | sed 's/[.].*//')
      echo "$KDIR" | grep -q ^nvidia[0-9]*$ && rename "nvidia" "$KDIR" $(dirname $a)/nvidia*
  done
fi

#BUGFIX install all dkms binary modules
if [ -d /var/lib/dkms-binary/ ] ;then
  for a in /var/lib/dkms-binary/* ;do
    [ -d "$a" ] || continue
    grep BUILT_MODULE_NAME "$a"/*/*/dkms.conf | tr -d \"\' | while read b ;do
       KERN=$(dirname "$a"/*/*/dkms.conf)
       KERN=$(basename "$KERN")
       MODULE=$(echo $b | awk -F= '{print $2}')
       PLACEKEY=$(echo $b | sed s/BUILT_MODULE_NAME/DEST_MODULE_LOCATION/ | awk -F= '{print $1}' | tr '[]' .)
       PLACELOC=$(grep $PLACEKEY= "$a"/*/*/dkms.conf | awk -F= '{print $2}' | tr -d \"\')
       [ -z "PLACELOC" ] && PLACELOC=3rdparty/$(basename $a)
       mkdir -p $KLIBDIR/$KERN$PLACELOC
       cp -pf $a/*/*/*/module/$MODULE.ko* $KLIBDIR/$KERN$PLACELOC
    done
  done
fi

rm -fr "$KLIBDIR"*"rosa-flow-abi"
for a in "$KLIBDIR"/*-* ;do
#  echo processing kernel $a
   rm -f $a/kernel/zzz-*-abi 2>/dev/null
   KVER=$(basename $a)
   /sbin/depmod -a $KVER
   [ -h $a/build ] || ln -sf $(find /usr/src -maxdepth 2 -type d -name *$KVER | head -1) $a/build
   [ -h $a/source ] || ln -sf build $a/source
done
ln -sf $(ls -1 /boot/vmlinuz-* | tail -1 | sed 's|/boot/||') /boot/vmlinuz

exit 0
