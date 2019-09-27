#!/bin/bash
urpmi grub2-efi

EFIARCH=x86_64-efi
EFILIB=/usr/lib/grub/x86_64-efi
EFINAME=grubx64.efi
if [ -d /usr/lib/grub/i386-efi ] ;then
  EFIARCH=i386-efi
  EFILIB=/usr/lib/grub/i386-efi
  EFINAME=grubia32.efi
fi

grub2-mkimage --compress=xz -O $EFIARCH -d $EFILIB -o $PWD/$EFINAME -p "/boot/grub/magos" \
acpi at_keyboard \
bitmap bitmap_scale boot btrfs \
cat chain configfile cpuid \
echo efi_gop efi_uga elf emuusb ext2 exfat \
fat font \
gettext gfxmenu gfxterm gzio \
halt hashsum help http hfsplus \
iso9660 \
jpeg \
loadbios loadenv linux linuxefi loopback ls lspci \
memdisk \
net normal ntfs ntfscomp \
part_gpt part_msdos password png \
reboot regexp \
sleep search search_fs_file search_fs_uuid search_label squash4 \
tar terminal test testload tftp time true \
udf usb usb_keyboard usbms \
video video_fb
