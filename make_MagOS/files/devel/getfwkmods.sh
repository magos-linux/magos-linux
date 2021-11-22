#!/bin/bash
# script lists kernel mods for firmwares (if kernel mods are unpacked in /lib/modules)
rm -f fwlist.tmp 2>/dev/null
KERN=/lib/modules/$(uname -r)/kernel
find /lib/firmware -type f | sort | while read a ;do
  FW=$(basename $a)
  echo $FW
  grep -Rl $FW $KERN 2>/dev/null | sed s=$KERN== | while read b  ;do
      echo $b $a >> fwlist.tmp
  done
done
cat fwlist.tmp | sort -u > fwlist.txt
rm -f fwlist.tmp
sed -i /.lib.firmware.configure$/d fwlist.txt
sed -i /README$/d fwlist.txt
