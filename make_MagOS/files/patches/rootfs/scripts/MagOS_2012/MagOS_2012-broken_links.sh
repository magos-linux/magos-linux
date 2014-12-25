#!/bin/sh
[ -h usr/share/zoneinfo/posix ] || exit 0
rm -f usr/share/zoneinfo/posix
mkdir usr/share/zoneinfo.posix
ls usr/share/zoneinfo | while read a ;do
   ln -sf ../$a usr/share/zoneinfo.posix/$a
done
mv usr/share/zoneinfo.posix usr/share/zoneinfo/posix
exit 0
