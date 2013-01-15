#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    [[ "$mount_needs" ]] && return 1
    [[ -x /sbin/plymouthd && -x /bin/plymouth && -x /usr/sbin/plymouth-set-default-theme ]]
}

depends() {
    return 0
}

installkernel() {
    return 0
}

install() {
    if grep -q nash /usr/libexec/plymouth/plymouth-populate-initrd \
        || ! grep -q PLYMOUTH_POPULATE_SOURCE_FUNCTIONS /usr/libexec/plymouth/plymouth-populate-initrd \
        || [ ! -x /usr/libexec/plymouth/plymouth-populate-initrd ]; then
        . "$moddir"/plymouth-populate-initrd
    else
        PLYMOUTH_POPULATE_SOURCE_FUNCTIONS="$dracutfunctions" \
            /usr/libexec/plymouth/plymouth-populate-initrd -t $initdir
    fi

    inst_hook pre-pivot 90 "$moddir"/plymouth-newroot.sh
    inst_hook pre-trigger 10 "$moddir"/plymouth-pretrigger.sh
    inst_hook pre-pivot 10 "$moddir"/plymouth-cleanup.sh
    inst_hook emergency 50 "$moddir"/plymouth-emergency.sh
    inst readlink
}

