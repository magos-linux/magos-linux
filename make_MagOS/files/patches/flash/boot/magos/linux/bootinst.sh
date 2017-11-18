#!/bin/bash

set -e
TARGET=""
MBR=""
SYSLINUXFS=" btrfs xfs "

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

# Find out which partition or disk are we using
MYMNT=$(readlink -f "$0")
while [ "$MYMNT" != "" -a "$MYMNT" != "." -a "$MYMNT" != "/" -a "$TARGET" == "" ]; do
   MYMNT=$(dirname "$MYMNT")
   TARGET=$(egrep "[^[:space:]]+[[:space:]]+$MYMNT[[:space:]]+" /proc/mounts | cut -d " " -f 1)
done

if [ "$TARGET" = "" ]; then
   t_echo "Can't find device to install to."
   t_echo "Make sure you run this script from a mounted device."
   exit 1
fi

if [ "$(cat /proc/mounts | grep "^$TARGET[[:space:]]" | grep noexec)" ]; then
   t_echo "The disk" $TARGET "is mounted with noexec parameter, trying to remount..."
   mount -o remount,exec "$TARGET"
fi

MBR=$(echo "$TARGET" | sed -r "s/[0-9]+\$//g")
NUM=${TARGET:${#MBR}}
FS=$(grep "$TARGET " /proc/mounts | gawk '{print $3}')
cd "$MYMNT"
clear
t_echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
t_echo "Welcome to MagOS boot installer"
t_echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo
t_echo "This installer will setup disk" "$MYMNT" "($TARGET,$FS)" "to boot only MagOS."
if [ "$MBR" != "$TARGET" ]; then
   t_echo
   t_echo "Warning! Master boot record (MBR) of" $MBR "will be overwritten."
   t_echo "If you use" $MBR "to boot any existing operating system, it will not work"
   t_echo "anymore. Only MagOS will boot from this device. Be careful!"
fi
t_echo
t_echo "Press Enter to continue, or Ctrl+C to abort..."
read junk
clear

t_echo "Flushing filesystem buffers, this may take a while..."
sync

# setup MBR if the device is not in superfloppy format
if [ "$MBR" != "$TARGET" ]; then
   GPT= ; if fdisk -l "$MBR" | grep -qi gpt ;then GPT=gpt ;fi
   BACKUP=mbr$GPT-$(date +%Y%m%d-%H%M%S).bak
   t_echo "Saving current  MBR to file" $BACKUP...
   dd if=$MBR of=./boot/magos/$BACKUP count=1
   if [ "$GPT" == "" ] ;then
     if [ -x /sbin/parted -o -x /usr/sbin/parted ] ;then
       t_echo "Activating partition" $TARGET...
       parted -s $MBR set $NUM boot on
     else
       t_echo "Can't find utility" "parted.""You have to set boot flag on partition youself."
     fi
   else
     if [ -x /sbin/parted -o -x /usr/sbin/parted ] ;then
       t_echo "Activating partition" $TARGET...
       parted -s $MBR set $NUM legacy_boot on
     else
       t_echo "Can't find utility" "parted.""You have to set legacy_boot flag on partition youself."
     fi
   fi
   t_echo "Updating MBR on" $MBR...
   cat ./boot/syslinux/lib/mbr$GPT.bin > $MBR
fi

t_echo "Installing syslinux boot loader for" "$MYMNT" "($TARGET,$FS)..."
./boot/syslinux/extlinux -i "$MYMNT" || exit 1

t_echo "Setting up syslinux for" "$FS..."
DEFAULT=grub4dos
if echo "$SYSLINUXFS" | grep -q " $FS " ;then
  DEFAULT=menu
  if ! t_echo "Setting up syslinux for" | grep -q "Setting up syslinux for" ;then  DEFAULT=local ;fi
fi
sed -i s/DEFAULT.*/"DEFAULT $DEFAULT"/ ./boot/syslinux/syslinux.cfg

t_echo "Disk" "$MYMNT" "($TARGET)" "should be bootable now. Installation finished."

echo
t_echo "Read the information above and then press Enter to exit..."
read junk
