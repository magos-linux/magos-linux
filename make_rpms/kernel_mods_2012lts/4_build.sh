#!/bin/bash
for a in dkms/* ;do
   echo $a
   . .config || exit 1
   . $a/.config || exit 1
   dkms --rpm_safe_upgrade add -m $MOD -v $VER -k $KERN
   dkms --rpm_safe_upgrade build -m $MOD -v $VER -k $KERN
   dkms --rpm_safe_upgrade mkrpm -m $MOD -v $VER -k $KERN || exit 1
done
echo Done.

