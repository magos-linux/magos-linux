#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

. /mnt/live/liblinuxlive
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS

PATH=/usr/lib/magos/scripts:$PATH

# save2module mode parser
cat /proc/config.gz | gunzip | grep -q SQUASHFS_XZ && MODULEFORMAT=xzm || MODULEFORMAT=lzm
SRC=/mnt/live/memory/changes
[ -z "$SAVETOMODULENAME" -a -w /mnt/livedata/$LIVECDNAME-Data/modules ] && SAVETOMODULENAME=/mnt/livedata/$LIVECDNAME-Data/modules/zz-save.$MODULEFORMAT
[ -z "$SAVETOMODULENAME" -a -w /mnt/livemedia/$LIVECDNAME/modules ] && SAVETOMODULENAME=/mnt/livemedia/$LIVECDNAME/modules/zz-save.$MODULEFORMAT
[ -f /.savetomodule ] && grep -q . /.savetomodule && SAVETOMODULENAME="$(cat /.savetomodule)"
SAVETOMODULEDIR="$(dirname $SAVETOMODULENAME)"
FILELIST=/.savelist
[ -f /.savetomodule ] && SAVETOMODULE=${SAVETOMODULE-yes}
grep -q save2module /proc/cmdline && SAVETOMODULE=${SAVETOMODULE-yes}
grep -q /machines/dynamic/ /.savetomodule 2>/dev/null  && [ -f $(sed s=dynamic=static= /.savetomodule) ] && SAVETOMODULE=no
if [ -w $SAVETOMODULEDIR -a "$SAVETOMODULE" = "yes" ] ;then
   echo "Please wait. Saving changes to module $SAVETOMODULENAME"
   # if old module exists we have to concatenate it
   if [ -d /mnt/live/memory/images/${SAVETOMODULENAME##*/} ]; then
      SRC=/mnt/live/tmp/save2module
      mkdir $SRC $SRC-rw
      mount -t aufs -o shwh,br:$SRC-rw=rw:/mnt/live/memory/changes=rr:/mnt/live/memory/images/${SAVETOMODULENAME##*/}=rr aufs $SRC
   fi
   # preparing excluded files list
   echo -e "/tmp/includedfiles\n/tmp/excludedfiles" > /tmp/excludedfiles
   if [ -f "$FILELIST" ] ;then
      grep ^! "$FILELIST" | cut -c 2- >/tmp/savelist.black
      grep -v '^[!#]' "$FILELIST" | grep . >/tmp/savelist.white
      grep -q . /tmp/savelist.white || echo '.' > /tmp/savelist.white
      find $SRC/ -type l >/tmp/allfiles
      find $SRC/ -type f >>/tmp/allfiles
      sed -i 's|'$SRC'||' /tmp/allfiles
      grep -f /tmp/savelist.white /tmp/allfiles | grep -vf /tmp/savelist.black > /tmp/includedfiles
      grep -q . /tmp/savelist.black && grep -f /tmp/savelist.black /tmp/allfiles >> /tmp/excludedfiles
      grep -vf /tmp/savelist.white /tmp/allfiles >> /tmp/excludedfiles
      find $SRC/ -type d | sed 's|'$SRC'||' | while read a ;do
          grep -q "^$a" /tmp/includedfiles && continue
          echo "$a" | grep -vf /tmp/savelist.black | grep -qf /tmp/savelist.white && continue
          echo "$a" >> /tmp/excludedfiles
      done
      rm -f /tmp/savelist* /tmp/allfiles /tmp/includedfiles
   fi
   sed -i 's|^/||' /tmp/excludedfiles
   # backuping old module
   [ -f "$SAVETOMODULENAME" ] && mv -f "$SAVETOMODULENAME" "${SAVETOMODULENAME}.bak"
   # making module
   [ "$SAVETONOLZMA" = "yes" ] && SAVETOMODULEOPTIONS="$SAVETOMODULEOPTIONS -noI -noD -noF -nolzma"
   create_module $SRC "$SAVETOMODULENAME" -ef /tmp/excludedfiles $SAVETOMODULEOPTIONS
   echo
   [ "$SRC" = "/mnt/live/memory/changes" ] || umount "$SRC"
fi

sync
