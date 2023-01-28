#!/bin/bash
FILE="$1"
if ! [ "$FILE" ] ;then
   echo This script add string \'script = \"griff_explosionScript.js\"\' to all ships in file shipdata.plist;
   echo Usage $0 [/path/to/]shipdata.plist
   exit 1
fi
grep -q 'griff_explosionScript.js' "$FILE" && exit 0
grep 'roles = ' $FILE | grep -E 'hunter|trader|buoy|miner|escort|shuttle|police|interceptor|wingman|pirate' | \
  sort -u | while read a ;do
      STR=$(echo "$a"| sed s/\"/./g)
      echo $STR
      sed -i /"$STR"/s/$/'\n		script = "griff_explosionScript.js";'/ "$FILE"
  done
