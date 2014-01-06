#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

mount_root() {

. /livekitlib

#transfer_initramfs

MEMORY=/memory
CHANGES=$MEMORY/changes
UNION=$NEWROOT
DATAMNT=$MEMORY/data
BUNDLES=$MEMORY/bundles
LIVEKITNAME="MagOS"
BEXT=xzm

header "Live Kit init <http://www.linux-live.org/>"

mkdir -p $MEMORY
mount -t tmpfs -o size="100%" tmpfs $MEMORY

#init_proc_sysfs

debug_start
                                                                                                                                                       debug_shell
#init_devs
init_aufs
#init_zram

# find data dir with filesystem bundles
DATA="$(find_data 60 "$DATAMNT")"
                                                                                                                                                      debug_shell
# setup persistent changes, if possible
persistent_changes "$DATA" "$CHANGES"
                                                                                                                                                      debug_shell
# copy to RAM if needed
DATA="$(copy_to_ram "$DATA" "$CHANGES")"
                                                                                                                                                      debug_shell
# init aufs union
init_union "$CHANGES" "$UNION"
                                                                                                                                                      debug_shell
# add data to union
union_append_bundles "$DATA" "$BUNDLES" "$UNION"
                                                                                                                                                      debug_shell
# rootcopy
#copy_rootcopy_content "$DATA" "$UNION"

# create empty fstab
#fstab_create "$UNION"
                                                                                                                                                      debug_shell
#header "Live Kit done, starting $LIVEKITNAME"
#change_root "$UNION"

#header "!!ERROR occured, you shouldn't be here.!!"
#/bin/sh

#need for usable_root of dracut
mkdir -p $UNION/proc $UNION/sys $UNION/dev $UNION/$MEMORY
mount -o bind $MEMORY $UNION/$MEMORY


}

if [ -n "$root" -a -z "${root%%magos:*}" ]; then
    mount_root
fi

