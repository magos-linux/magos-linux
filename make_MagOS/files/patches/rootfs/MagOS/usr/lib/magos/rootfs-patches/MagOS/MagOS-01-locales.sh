#!/bin/bash
ln -sf /usr/share/locale /etc/locale

#creating locales archive
LOCALEARCHIVE="en_US ru_RU"
if [ -x /usr/bin/localedef ] ;then
   for a in $LOCALEARCHIVE ;do
      localedef -c -f UTF-8 -i "$a" $a.UTF-8
   done
fi

exit 0
