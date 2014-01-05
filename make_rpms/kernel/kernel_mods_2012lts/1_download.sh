#!/bin/bash
mkdir -p cache
PC="$PWD"
for a in dkms/* ;do
   echo $a
   . .config || exit 1
   . $a/.config || exit 1
   curl -# --retry-delay 2 --retry 5 -o cache/dkms-$MOD-$VER-$SYS.i586.rpm ${REP}dkms-$MOD-$VER-$SYS.$ARCH.rpm || exit 1
done
echo Done.

