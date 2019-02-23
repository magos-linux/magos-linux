#!/bin/bash
PFP=/etc/bash_completion.d/urpmi
if ! grep -q "urpm2xzm" $PFP ;then
   sed -i s%"urpmi gurpmi rurpmi"$%"urpmi gurpmi rurpmi urpm2xzm"% $PFP
   sed -i s%"for everything else as rurpmi"$%"for everything else as rurpmi"\\n'[[ ${COMP_WORDS[0]} == *urpm2pfs ]] \&\& options=\"$options --help --mask --rpmdb --urpmidb --erase --rebuildable --fast --steps --bulddir --load --info -urpmi --urpmi'\"% $PFP
fi

exit 0
