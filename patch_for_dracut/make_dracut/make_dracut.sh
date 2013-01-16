#!/bin/bash
 cp -pRf dracut_patch/* /usr/lib/dracut/modules.d
[ -f /etc/modprobe.conf ] && mv /etc/modprobe.conf /etc/modprobe.conf.bak
dracut  -m "dash rpmversion network ifcfg plymouth crypt nfs resume rootfs-block terminfo udev-rules aufs-mount base ntfs fs-lib kernel-modules magos busybox"  \
        -d "aes-i586 aes_generic cbc loop cryptoloop zlib_deflate crc-t10dif crc16 \
           dca hid usbhid libphy mii virtio_net pcmcia pcmcia_core yenta_socket \
           scsi_mod sd_mod sr_mod vmw_pvscsi usb-common usbcore ehci-hcd uhci-hcd ohci-hcd \
           uas ums-datafab ums-isd200 ums-onetouch ums-sddr55 ums-alauda ums-eneub6250 ums-jumpshot \
           ums-realtek ums-usbat ums-cypress ums-freecom ums-karma ums-sddr09 usb-storage \
           acard-ahci pata_arasan_cf pata_cypress pata_legacy pata_pcmcia pata_sil680 sata_qstor \
           ahci pata_artop pata_efar pata_marvell pata_pdc2027x pata_sis sata_sil24 \
           ahci_platform pata_atiixp pata_hpt366 pata_mpiix pata_pdc202xx_old pata_sl82c105 sata_sil \
           ata_generic pata_atp867x pata_hpt37x pata_netcell pata_piccolo pata_triflex sata_sis \
           ata_piix pata_cmd640 pata_hpt3x2n pata_ninja32 pata_radisys pata_via sata_svw \
           libahci pata_cmd64x pata_hpt3x3 pata_ns87410 pata_rdc pdc_adma sata_sx4 \
           libata pata_cs5520 pata_isapnp pata_ns87415 pata_rz1000 sata_inic162x sata_uli \
           pata_acpi pata_cs5530 pata_it8213 pata_oldpiix pata_sc1200 sata_mv sata_via \
           pata_ali pata_cs5535 pata_it821x pata_optidma pata_sch sata_nv sata_vsc \
           pata_amd pata_cs5536 pata_jmicron pata_opti pata_serverworks sata_promise" \
        --filesystems "aufs squashfs ext3 ext4 fat msdos vfat fscache fuse isofs jbd jbd2 lockd nfs_acl ntfs reiserfs unionfs xfs nfs nls_cp866 nls_utf8" \
        -c dracut.conf -v -M dracut.cpio.gz $(uname -r) >dracut.log 2>&1
gunzip -f dracut.cpio.gz
