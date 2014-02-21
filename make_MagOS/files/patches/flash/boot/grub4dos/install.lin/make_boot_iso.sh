#!/bin/bash
# ---------------------------------------------------
# Script to create bootable ISO in Linux
# usage: make_iso.sh [ /tmp/MagOS.iso ]
# author: Tomas M. <http://www.linux-live.org>
# ---------------------------------------------------

[ -f $(basename $0) ] || cd $(dirname $0)

LOCF=`pwd`/`locale | grep ^LANG= | awk -F= '{print $2}'`
function t_echo()
{
  STR=""
  while [ "$1" != "" ] ;do
      if grep -q "^$1|" $LOCF 2>/dev/null ;then
         STR="$STR `grep "^$1|" $LOCF | awk -F\| '{print $2}'`"
      else
         STR="$STR $1"
      fi
      shift
  done
  echo $STR
}

if [ "$1" = "--help" -o "$1" = "-h" ]; then
  t_echo "This script will create bootable ISO"
  exit
fi

CDLABEL="MagOSboot"

cd $(dirname $0)
SUGGEST=$(readlink -f ../../../../$CDLABEL.iso)
t_echo -ne "Target ISO file name" [ "Hit enter for" $SUGGEST "]: "
read ISONAME
[ "$ISONAME" = "" ] && ISONAME="$SUGGEST"

mkisofs -o "$ISONAME" -v -J -R -D -A "$CDLABEL" -V "$CDLABEL" \
-no-emul-boot -boot-info-table -boot-load-size 4 -b magos.ldr -c boot/grub4dos/boot.catalog \
-graft-points boot=../../../boot magos.ldr=../magos.ldr  \
MagOS/vmlinuz=../../../MagOS/vmlinuz MagOS/initrd.gz=../../../MagOS/initrd.gz
