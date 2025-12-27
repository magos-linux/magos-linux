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
cd ../../../
SUGGEST=$(readlink -f ./$CDLABEL.iso)
t_echo -ne "Target ISO file name" [ "Hit enter for" $SUGGEST "]: "
read ISONAME
[ "$ISONAME" = "" ] && ISONAME="$SUGGEST"

xorriso -as mkisofs -o "$ISONAME" -v -J -R -D -A "$CDLABEL" -V "$CDLABEL" \
 -graft-points -m '*_save*' boot=boot EFI=EFI isomode=boot/grub4dos/iso_conf \
 MagOS/vmlinuz=MagOS/vmlinuz MagOS/initrd.gz=MagOS/initrd.gz MagOS/uird.magos.cpio.xz=MagOS/uird.magos.cpio.xz \
 --no-emul-boot -boot-info-table -boot-load-size 4 --boot-catalog-hide \
 -b boot/grub4dos/magos.ldr -iso_mbr_part_type 0x83 --mbr-force-bootable --partition_offset 16 \
 -eltorito-alt-boot -isohybrid-mbr boot/syslinux/isohdpfx.bin -e EFI/efi.img
