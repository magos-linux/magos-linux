#!/bin/bash
mkdir -p rpms
for a in dkms/* ;do
   echo $a
   cd $a || exit 1
   . .config || exit 1
   mv /var/lib/dkms/$MOD/$VER/rpm/*.rpm ../../rpms
   cd ../../
done
echo Done.
