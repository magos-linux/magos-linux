#!/bin/bash
mkdir -p boot/dracut.tmp
rm -rf usr/lib/dracut/modules.d/97uird usr/lib/dracut/modules.d/98uird-network usr/lib/dracut/modules.d/90ntfs
cp -pRf usr/share/magos/uird/modules.d/* usr/lib/dracut/modules.d
KERNV=$(ls -1 /lib/modules | grep -m1 . | sed s=/$==)

chroot ./ dracut -N -f -m "base uird uird-network ntfs kernel-modules"  \
        -d "loop cryptoloop zram aes-generic aes-i586 pata_acpi ata_generic ahci xhci-hcd \
            usb-storage uhci-hcd hid usbhid ehci-hcd ohci-hcd ehci-pci ehci-platform hid-generic \
            sr_mod sd_mod scsi_mod \
             jbd jbd2 lockd evdev \
            af_packet \
            =ide =ata =ethernet =usb/storage =usb/host =nfs" \
        --filesystems "aufs squashfs vfat msdos iso9660 isofs xfs ext3 ext4 fuse nfs cifs udf nls_cp866 nls_utf8 " \
        --confdir "/usr/share/magos/uird/dracut.conf.d" \
        -i initrd / \
        --kernel-cmdline "uird.from=/MagOS,/MagOS-Data uird.ro=*.xzm,*.rom,*.rom.enc,*.pfs,*.sfs uird.rw=*.rwm,*.rwm.enc uird.cp=*.xzm.cp,*/rootcopy uird.load=* uird.noload=/optional/,/machines/,*/homes/*.xzm,/cache/ uird.machines=/MagOS-Data/machines uird.config=MagOS.ini" \
        -c dracut.conf -v -M /boot/uird.magos.cpio.xz $KERNV  --tmpdir /boot/dracut.tmp >boot/dracut.log 2>&1

rm -fr boot/dracut.tmp
