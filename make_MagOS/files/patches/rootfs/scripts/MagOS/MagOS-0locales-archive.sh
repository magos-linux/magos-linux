#!/bin/bash
#creating locales archive
LOCALEARCHIVE="en_US ru_RU"
if [ -x /usr/bin/localedef ] ;then
   rm -f usr/lib/locale/locale-archive 2>/dev/null
   for a in $LOCALEARCHIVE ;do
      chroot . localedef -c -f UTF-8 -i "$a" $a.UTF-8
   done
fi
