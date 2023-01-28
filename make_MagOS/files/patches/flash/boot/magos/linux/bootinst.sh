#!/bin/bash
set -e
TARGET=""
MBR=""
SYSLINUXFS=" btrfs xfs "
WP=$(readlink -f "$0")
WP=$(dirname "$WP")
LOCF="$WP"/`locale | grep ^LANG= | awk -F= '{print $2}'`
TMPBIN="/tmp/$USER-syslinux4magos.tmp"
function t_echo()
{
  STR=""
  while [ "$1" != "" ] ;do
       if grep -q "^$1|" "$LOCF" 2>/dev/null ;then
          LSTR=$(grep "^$1|" "$LOCF" | awk -F\| '{print $2}')
          STR="$STR $LSTR"
       else
          STR="$STR $1"
       fi
       shift
  done
  echo $STR
}

clear
t_echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
t_echo "Welcome to MagOS boot installer"
t_echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo
# Find out which partition or disk are we using
MYMNT="$WP"
while [ "$MYMNT" != "" -a "$MYMNT" != "." -a "$MYMNT" != "/" -a "$TARGET" == "" ]; do
    MYMNT=$(dirname "$MYMNT")
    TARGET=$(df "$MYMNT" | grep "[[:space:]]$MYMNT"$ | gawk '{print $1}')
done

if [ "$TARGET" == "" -o "$MYMNT" == "/" ]; then
   t_echo "Can't find device to install to."
   t_echo "Make sure you run this script from a mounted device."
   exit 1
fi

MBR=$(echo "$TARGET" | sed -r "s/[0-9]+\$//g")
NUM=${TARGET:${#MBR}}
FS=$(grep -m1 "$TARGET " /proc/mounts | gawk '{print $3}')
FSOPTS=$(grep -m1 "$TARGET " /proc/mounts | gawk '{ print $4}')

if ! [ -w "$TARGET" ] ;then
  t_echo "You have not rights to write on " "$TARGET""!" "Run as root."
  exit 1
fi

t_echo "This installer will setup disk to boot MagOS."
t_echo "Disk:" "$MYMNT" "($TARGET,$FS)"
if [ "$MBR" != "$TARGET" ]; then
   echo
   t_echo "Warning! Master boot record (MBR) of" $MBR "will be overwritten."
   t_echo "If you are using disk to boot any existing operating system,"
   t_echo "it will not work anymore. Only MagOS will boot from this device."
   t_echo "Be careful!"
fi
t_echo
t_echo "Press Enter to continue, or Ctrl+C to abort..."
read junk
clear

t_echo "Flushing filesystem buffers, this may take a while..."
sync

SYSLINUX="$MYMNT/boot/syslinux/extlinux"

if grep -qE "^$TARGET[[:space:]].*(noexec|showexec)" /proc/mounts ; then
   t_echo "The disk" $TARGET "is mounted with noexec parameter, copying syslinux to" "$TMPBIN"
   cp -f "$SYSLINUX" "$TMPBIN" || exit 1
   SYSLINUX="$TMPBIN"
   chmod 775 "$TMPBIN"
fi

# setup MBR if the device is not in superfloppy format
if [ "$MBR" != "$TARGET" ]; then
   GPT= ; if fdisk -l "$MBR" | grep -qi gpt ;then GPT=gpt ;fi
   BACKUP=mbr$GPT-$(date +%Y%m%d-%H%M%S).bak
   t_echo "Saving current MBR to" "$MYMNT/boot/magos/$BACKUP"
   dd if=$MBR of="$MYMNT/boot/magos/$BACKUP" count=1
   if [ "$GPT" == "" ] ;then
     if [ -x /sbin/parted -o -x /usr/sbin/parted ] ;then
       t_echo "Activating partition" $TARGET...
       parted -s $MBR set $NUM boot on
     else
       t_echo "Can't find utility" "parted." "You have to set boot flag on partition youself."
     fi
   else
     if [ -x /sbin/parted -o -x /usr/sbin/parted ] ;then
       t_echo "Activating partition" $TARGET...
       parted -s $MBR set $NUM legacy_boot on
     else
       t_echo "Can't find utility" "parted." "You have to set legacy_boot flag on partition youself."
     fi
   fi
   t_echo "Updating MBR on" $MBR...
   cat "$MYMNT/boot/syslinux/lib/mbr$GPT.bin" > $MBR
fi

t_echo "Installing syslinux boot loader for" "$MYMNT" "($TARGET,$FS)..."
"$SYSLINUX" -i "$MYMNT" || exit 1

t_echo "Setting up syslinux for" "$FS..."
DEFAULT=grub4dos
if echo "$SYSLINUXFS" | grep -q " $FS " ;then
  DEFAULT=menu
  if ! t_echo "Setting up syslinux for" | grep -q "Setting up syslinux for" ;then  DEFAULT=local ;fi
fi
sed -i s/DEFAULT.*/"DEFAULT $DEFAULT"/ "$MYMNT/boot/syslinux/syslinux.cfg"
if [ -f "$TMPBIN" ] ;then rm -f "$TMPBIN" ;fi

t_echo "Disk" "$MYMNT" "($TARGET)" "should be bootable now."
t_echo "Installation finished."

echo
t_echo "Read the information above and then press Enter to exit..."
read junk
