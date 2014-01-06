#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# root=magos:<mountpoint>:<base_from>:<data_from>[,<options>]
#

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh
. /lib/magos-lib.sh

#Don't continue if root is ok
[ -n "$rootok" ] && return

# This script is sourced, so root should be set. But let's be paranoid
[ -z "$root" ] && root=$(getarg root=)

# If it's not magos we don't continue
[ "${root%%:*}" = "magos" ] || return

# Check required arguments
magos_to_var $root

[ -n "$base_from" ] || die "Argument magosroot needs base_from param"
[ -n "$data_from" ] || die "Argument magosroot needs data_from param"



# Done, all good!
rootok=1
