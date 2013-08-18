#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    return 0
}

depends() {
    # We depend on network modules being loaded
    echo busybox
}

installkernel() {
    instmods aes-i586 aes_generic cbc loop cryptoloop zlib_deflate crc-t10dif crc16 \
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
             pata_amd pata_cs5536 pata_jmicron pata_opti pata_serverworks sata_promise scsi_wait_scan crc-itu-t
    instmods aufs squashfs ext3 ext4 fat msdos vfat fscache fuse isofs jbd jbd2 lockd nfs_acl ntfs reiserfs unionfs xfs nfs nls_cp866 nls_utf8
}

install() {
    #kernel modules
    inst_hook cmdline 01 "/usr/lib/dracut/modules.d/90kernel-modules/parse-kernel.sh"
#    inst_hook pre-pivot 20 "/usr/lib/dracut/modules.d/90kernel-modules/kernel-cleanup.sh"
    inst_simple "/usr/lib/dracut/modules.d/90kernel-modules/insmodpost.sh" /sbin/insmodpost.sh

    for _f in modules.builtin.bin modules.builtin; do
        [[ $srcmods/$_f ]] && break
    done || {
        dfatal "No modules.builtin.bin and modules.builtin found!"
        return 1
    }

    for _f in modules.builtin.bin modules.builtin modules.order; do
        [[ $srcmods/$_f ]] && inst_simple "$srcmods/$_f" "/lib/modules/$kernel/$_f"
    done
    #mc
    dracut_install /usr/bin/mc /usr/bin/mcview /usr/bin/mcedit /usr/bin/mcdiff
    dracut_install /usr/share/mc/*
    dracut_install /usr/share/mc/examples/macros.d/*
    dracut_install /usr/share/mc/help/*
    dracut_install /usr/share/mc/skins/*
    dracut_install /usr/share/mc/syntax/*
    
    inst /sbin/blkid /sbin/blkid.large
    #curlftpfs
    #dracut_install /usr/bin/curlftpfs
    
    #magos 
    inst "$moddir/linuxlive/VERSION" "/VERSION"
    inst "$moddir/linuxlive/liblinuxlive" "/liblinuxlive"
    inst "$moddir/linuxlive/linuxrc" "/linuxrc"
#    inst "$moddir/functions" /lib/magosfunctions
#    inst "$moddir/linuxrc" /linuxrc
#    inst "$moddir/liblinuxlive" /liblinuxlive

    inst_hook cmdline 95 "$moddir/parse-magosroot.sh"
    inst_hook mount 99 "$moddir/mount-magos.sh"
    inst "$moddir/magos-lib.sh" "/lib/magos-lib.sh"

#    inst_hook pre-pivot 90 "$moddir"/magos-pre.sh
#    inst_hook cmdline 99 "$moddir"/parse-magos.sh
#    inst_hook mount 90 "$moddir"/magos-mount.sh
}

